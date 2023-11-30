import {
    generateStreamFromArrayBuffer,
    getRenderableFileURL,
} from 'utils/file';
import { EnteFile } from 'types/file';

import { logError } from '@ente/shared/sentry';
import { FILE_TYPE } from 'constants/file';
import { CustomError } from '@ente/shared/error';
import ComlinkCryptoWorker from '@ente/shared/crypto';
import { CacheStorageService } from '@ente/shared/storage/cacheStorage';
import { CACHES } from '@ente/shared/storage/cacheStorage/constants';
import { Remote } from 'comlink';
import { DedicatedCryptoWorker } from '@ente/shared/crypto/internal/crypto.worker';
import { LimitedCache } from '@ente/shared/storage/cacheStorage/types';
import { addLogLine } from '@ente/shared/logging';
import { APPS } from '@ente/shared/apps/constants';
import { PhotosDownloadClient } from './downloadManagerClients/photos';
import { PublicAlbumsDownloadClient } from './downloadManagerClients/publicAlbums';

export type SourceURLs = {
    original: string[];
    converted: string[];
};

export type OnDownloadProgress = (event: {
    loaded: number;
    total: number;
}) => void;

export interface DownloadClient {
    updateTokens: (token: string, passwordToken?: string) => void;
    updateTimeout: (timeout: number) => void;
    downloadThumbnail: (
        file: EnteFile,
        timeout?: number
    ) => Promise<Uint8Array>;
    downloadFile: (
        file: EnteFile,
        onDownloadProgress: OnDownloadProgress
    ) => Promise<Uint8Array>;
    downloadFileStream: (file: EnteFile) => Promise<Response>;
}

class DownloadManager {
    private downloadClient: DownloadClient;
    private thumbnailCache: LimitedCache;
    private cryptoWorker: Remote<DedicatedCryptoWorker>;

    private fileObjectURLPromises = new Map<number, Promise<SourceURLs>>();
    private thumbnailObjectURLPromises = new Map<number, Promise<string>>();

    private fileDownloadProgress = new Map<number, number>();

    private progressUpdater: (value: Map<number, number>) => void = () => {};

    async init(
        app: APPS,
        tokens: { token: string; passwordToken?: string } | { token: string },
        timeout?: number
    ) {
        this.downloadClient = createDownloadClient(app, tokens, timeout);
        this.thumbnailCache = await openThumbnailCache();
        this.cryptoWorker = await ComlinkCryptoWorker.getInstance();
    }

    updateToken(token: string, passwordToken?: string) {
        this.downloadClient.updateTokens(token, passwordToken);
    }

    updateCryptoWorker(cryptoWorker: Remote<DedicatedCryptoWorker>) {
        this.cryptoWorker = cryptoWorker;
    }

    updateTimeout(timeout: number) {
        this.downloadClient.updateTimeout(timeout);
    }

    setProgressUpdater(progressUpdater: (value: Map<number, number>) => void) {
        this.progressUpdater = progressUpdater;
    }

    private async getCachedThumbnail(fileID: number) {
        try {
            const cacheResp: Response = await this.thumbnailCache?.match(
                fileID.toString()
            );
            return await cacheResp.blob();
        } catch (e) {
            logError(e, 'failed to get cached thumbnail');
            throw e;
        }
    }

    private downloadThumb = async (file: EnteFile) => {
        const encrypted = await this.downloadClient.downloadThumbnail(file);
        const decrypted = await this.cryptoWorker.decryptThumbnail(
            encrypted,
            await this.cryptoWorker.fromB64(file.thumbnail.decryptionHeader),
            file.key
        );
        return decrypted;
    };

    public async getThumbnail(file: EnteFile) {
        try {
            const cachedThumb = await this.getCachedThumbnail(file.id);
            if (cachedThumb) {
                return cachedThumb;
            }
            const thumb = await this.downloadThumb(file);
            const thumbBlob = new Blob([thumb]);

            this.thumbnailCache
                ?.put(file.id.toString(), new Response(thumbBlob))
                .catch((e) => {
                    logError(e, 'cache put failed');
                    // TODO: handle storage full exception.
                });
            return thumbBlob;
        } catch (e) {
            logError(e, 'get DownloadManager preview Failed');
            throw e;
        }
    }

    public async getThumbnailForPreview(file: EnteFile) {
        try {
            if (!this.thumbnailObjectURLPromises.has(file.id)) {
                await this.thumbnailObjectURLPromises.get(file.id);
                const thumbBlobPromise = this.getThumbnail(file);
                const thumbURLPromise = thumbBlobPromise.then((blob) =>
                    URL.createObjectURL(blob)
                );
                this.thumbnailObjectURLPromises.set(file.id, thumbURLPromise);
            }
            return await this.thumbnailObjectURLPromises.get(file.id);
        } catch (e) {
            this.thumbnailObjectURLPromises.delete(file.id);
            logError(e, 'get DownloadManager preview Failed');
            throw e;
        }
    }

    getFileForPreview = async (file: EnteFile): Promise<SourceURLs> => {
        try {
            const getFilePromise = async () => {
                const fileStream = await this.downloadFile(file);
                const fileBlob = await new Response(fileStream).blob();
                return await getRenderableFileURL(file, fileBlob);
            };
            if (!this.fileObjectURLPromises.get(file.id)) {
                const fileURLs = getFilePromise() as Promise<SourceURLs>;
                this.fileObjectURLPromises.set(file.id, fileURLs);
            }
            const fileURLs = await this.fileObjectURLPromises.get(file.id);
            return fileURLs;
        } catch (e) {
            this.fileObjectURLPromises.delete(file.id);
            logError(e, 'download manager Failed to get File');
            throw e;
        }
    };

    getFile(file: EnteFile) {
        return this.downloadFile(file);
    }

    private async downloadFile(
        file: EnteFile
    ): Promise<ReadableStream<Uint8Array>> {
        try {
            const onDownloadProgress = this.trackDownloadProgress(
                file.id,
                file.info?.fileSize
            );
            if (
                file.metadata.fileType === FILE_TYPE.IMAGE ||
                file.metadata.fileType === FILE_TYPE.LIVE_PHOTO
            ) {
                const encrypted = await this.downloadClient.downloadFile(
                    file,
                    onDownloadProgress
                );
                this.clearDownloadProgress(file.id);
                try {
                    const decrypted = await this.cryptoWorker.decryptFile(
                        new Uint8Array(encrypted),
                        await this.cryptoWorker.fromB64(
                            file.file.decryptionHeader
                        ),
                        file.key
                    );
                    return generateStreamFromArrayBuffer(decrypted);
                } catch (e) {
                    if (e.message === CustomError.PROCESSING_FAILED) {
                        logError(e, 'Failed to process file', {
                            fileID: file.id,
                            fromMobile:
                                !!file.metadata.localID ||
                                !!file.metadata.deviceFolder ||
                                !!file.metadata.version,
                        });
                        addLogLine(
                            `Failed to process file with fileID:${file.id}, localID: ${file.metadata.localID}, version: ${file.metadata.version}, deviceFolder:${file.metadata.deviceFolder} with error: ${e.message}`
                        );
                    }
                    throw e;
                }
            }
            const resp = await this.downloadClient.downloadFileStream(file);
            const reader = resp.body.getReader();

            const contentLength = +resp.headers.get('Content-Length') ?? 0;
            let downloadedBytes = 0;

            const stream = new ReadableStream({
                start: async (controller) => {
                    try {
                        const decryptionHeader =
                            await this.cryptoWorker.fromB64(
                                file.file.decryptionHeader
                            );
                        const fileKey = await this.cryptoWorker.fromB64(
                            file.key
                        );
                        const { pullState, decryptionChunkSize } =
                            await this.cryptoWorker.initChunkDecryption(
                                decryptionHeader,
                                fileKey
                            );
                        let data = new Uint8Array();
                        // The following function handles each data chunk
                        const push = () => {
                            // "done" is a Boolean and value a "Uint8Array"
                            reader.read().then(async ({ done, value }) => {
                                try {
                                    // Is there more data to read?
                                    if (!done) {
                                        downloadedBytes += value.byteLength;
                                        onDownloadProgress({
                                            loaded: downloadedBytes,
                                            total: contentLength,
                                        });
                                        const buffer = new Uint8Array(
                                            data.byteLength + value.byteLength
                                        );
                                        buffer.set(new Uint8Array(data), 0);
                                        buffer.set(
                                            new Uint8Array(value),
                                            data.byteLength
                                        );
                                        if (
                                            buffer.length > decryptionChunkSize
                                        ) {
                                            const fileData = buffer.slice(
                                                0,
                                                decryptionChunkSize
                                            );
                                            try {
                                                const { decryptedData } =
                                                    await this.cryptoWorker.decryptFileChunk(
                                                        fileData,
                                                        pullState
                                                    );
                                                controller.enqueue(
                                                    decryptedData
                                                );
                                                data =
                                                    buffer.slice(
                                                        decryptionChunkSize
                                                    );
                                            } catch (e) {
                                                if (
                                                    e.message ===
                                                    CustomError.PROCESSING_FAILED
                                                ) {
                                                    logError(
                                                        e,
                                                        'Failed to process file',
                                                        {
                                                            fileID: file.id,
                                                            fromMobile:
                                                                !!file.metadata
                                                                    .localID ||
                                                                !!file.metadata
                                                                    .deviceFolder ||
                                                                !!file.metadata
                                                                    .version,
                                                        }
                                                    );
                                                    addLogLine(
                                                        `Failed to process file ${file.id} from localID: ${file.metadata.localID} version: ${file.metadata.version} deviceFolder:${file.metadata.deviceFolder} with error: ${e.message}`
                                                    );
                                                }
                                                throw e;
                                            }
                                        } else {
                                            data = buffer;
                                        }
                                        push();
                                    } else {
                                        if (data) {
                                            try {
                                                const { decryptedData } =
                                                    await this.cryptoWorker.decryptFileChunk(
                                                        data,
                                                        pullState
                                                    );
                                                controller.enqueue(
                                                    decryptedData
                                                );
                                                data = null;
                                            } catch (e) {
                                                if (
                                                    e.message ===
                                                    CustomError.PROCESSING_FAILED
                                                ) {
                                                    logError(
                                                        e,
                                                        'Failed to process file',
                                                        {
                                                            fileID: file.id,
                                                            fromMobile:
                                                                !!file.metadata
                                                                    .localID ||
                                                                !!file.metadata
                                                                    .deviceFolder ||
                                                                !!file.metadata
                                                                    .version,
                                                        }
                                                    );
                                                    addLogLine(
                                                        `Failed to process file ${file.id} from localID: ${file.metadata.localID} version: ${file.metadata.version} deviceFolder:${file.metadata.deviceFolder} with error: ${e.message}`
                                                    );
                                                }
                                                throw e;
                                            }
                                        }
                                        controller.close();
                                    }
                                } catch (e) {
                                    logError(e, 'Failed to process file chunk');
                                    controller.error(e);
                                }
                            });
                        };

                        push();
                    } catch (e) {
                        logError(e, 'Failed to process file stream');
                        controller.error(e);
                    }
                },
            });
            return stream;
        } catch (e) {
            logError(e, 'Failed to download file');
            throw e;
        }
    }

    trackDownloadProgress = (fileID: number, fileSize: number) => {
        return (event: { loaded: number; total: number }) => {
            if (isNaN(event.total) || event.total === 0) {
                if (!fileSize) {
                    return;
                }
                event.total = fileSize;
            }
            if (event.loaded === event.total) {
                this.fileDownloadProgress.delete(fileID);
            } else {
                this.fileDownloadProgress.set(
                    fileID,
                    Math.round((event.loaded * 100) / event.total)
                );
            }
            this.progressUpdater(new Map(this.fileDownloadProgress));
        };
    };

    clearDownloadProgress = (fileID: number) => {
        this.fileDownloadProgress.delete(fileID);
        this.progressUpdater(new Map(this.fileDownloadProgress));
    };
}

export default new DownloadManager();

async function openThumbnailCache() {
    try {
        return await CacheStorageService.open(CACHES.THUMBS);
    } catch (e) {
        logError(e, 'Failed to open thumbnail cache');
        return null;
    }
}

function createDownloadClient(
    app: APPS,
    tokens: { token: string; passwordToken?: string } | { token: string },
    timeout?: number
): DownloadClient {
    if (!timeout) {
        timeout = 300000; // 5 minute
    }
    if (app === APPS.ALBUMS) {
        const { token, passwordToken } = tokens as {
            token: string;
            passwordToken: string;
        };
        return new PublicAlbumsDownloadClient(token, passwordToken, timeout);
    } else {
        const { token } = tokens;
        return new PhotosDownloadClient(token, timeout);
    }
}
