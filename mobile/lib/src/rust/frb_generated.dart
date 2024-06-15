// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.39.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/simple.dart';
import 'api/usearch_api.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'frb_generated.io.dart' if (dart.library.html) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.crateApiSimpleInitApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.0.0-dev.39';

  @override
  int get rustContentHash => 2006111302;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_photos',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  String crateApiSimpleGreet({required String name});

  Future<void> crateApiSimpleInitApp();

  Future<void> crateApiUsearchApiAddVector(
      {required String indexPath,
      required BigInt key,
      required List<double> vector});

  Future<void> crateApiUsearchApiBulkAddVectors(
      {required String indexPath,
      required Uint64List keys,
      required List<Float32List> vectors});

  Future<(BigInt, BigInt, BigInt, BigInt, BigInt)>
      crateApiUsearchApiGetIndexStats({required String indexPath});

  Future<Float32List> crateApiUsearchApiGetVector(
      {required String indexPath, required BigInt key});

  Future<BigInt> crateApiUsearchApiRemoveVector(
      {required String indexPath, required BigInt key});

  Future<void> crateApiUsearchApiResetIndex({required String indexPath});

  Future<(Uint64List, Float32List)> crateApiUsearchApiSearchVectors(
      {required String indexPath,
      required List<double> query,
      required BigInt count});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  String crateApiSimpleGreet({required String name}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(name, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 1)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSimpleGreetConstMeta,
      argValues: [name],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleGreetConstMeta => const TaskConstMeta(
        debugName: "greet",
        argNames: ["name"],
      );

  @override
  Future<void> crateApiSimpleInitApp() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 2, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSimpleInitAppConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  @override
  Future<void> crateApiUsearchApiAddVector(
      {required String indexPath,
      required BigInt key,
      required List<double> vector}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        sse_encode_u_64(key, serializer);
        sse_encode_list_prim_f_32_loose(vector, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiAddVectorConstMeta,
      argValues: [indexPath, key, vector],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiAddVectorConstMeta =>
      const TaskConstMeta(
        debugName: "add_vector",
        argNames: ["indexPath", "key", "vector"],
      );

  @override
  Future<void> crateApiUsearchApiBulkAddVectors(
      {required String indexPath,
      required Uint64List keys,
      required List<Float32List> vectors}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        sse_encode_list_prim_u_64_strict(keys, serializer);
        sse_encode_list_list_prim_f_32_strict(vectors, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiBulkAddVectorsConstMeta,
      argValues: [indexPath, keys, vectors],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiBulkAddVectorsConstMeta =>
      const TaskConstMeta(
        debugName: "bulk_add_vectors",
        argNames: ["indexPath", "keys", "vectors"],
      );

  @override
  Future<(BigInt, BigInt, BigInt, BigInt, BigInt)>
      crateApiUsearchApiGetIndexStats({required String indexPath}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_record_usize_usize_usize_usize_usize,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiGetIndexStatsConstMeta,
      argValues: [indexPath],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiGetIndexStatsConstMeta =>
      const TaskConstMeta(
        debugName: "get_index_stats",
        argNames: ["indexPath"],
      );

  @override
  Future<Float32List> crateApiUsearchApiGetVector(
      {required String indexPath, required BigInt key}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        sse_encode_u_64(key, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_prim_f_32_strict,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiGetVectorConstMeta,
      argValues: [indexPath, key],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiGetVectorConstMeta =>
      const TaskConstMeta(
        debugName: "get_vector",
        argNames: ["indexPath", "key"],
      );

  @override
  Future<BigInt> crateApiUsearchApiRemoveVector(
      {required String indexPath, required BigInt key}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        sse_encode_u_64(key, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_usize,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiRemoveVectorConstMeta,
      argValues: [indexPath, key],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiRemoveVectorConstMeta =>
      const TaskConstMeta(
        debugName: "remove_vector",
        argNames: ["indexPath", "key"],
      );

  @override
  Future<void> crateApiUsearchApiResetIndex({required String indexPath}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 8, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiResetIndexConstMeta,
      argValues: [indexPath],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiResetIndexConstMeta =>
      const TaskConstMeta(
        debugName: "reset_index",
        argNames: ["indexPath"],
      );

  @override
  Future<(Uint64List, Float32List)> crateApiUsearchApiSearchVectors(
      {required String indexPath,
      required List<double> query,
      required BigInt count}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(indexPath, serializer);
        sse_encode_list_prim_f_32_loose(query, serializer);
        sse_encode_usize(count, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 9, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData:
            sse_decode_record_list_prim_u_64_strict_list_prim_f_32_strict,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiUsearchApiSearchVectorsConstMeta,
      argValues: [indexPath, query, count],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiUsearchApiSearchVectorsConstMeta =>
      const TaskConstMeta(
        debugName: "search_vectors",
        argNames: ["indexPath", "query", "count"],
      );

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  double dco_decode_f_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as double;
  }

  @protected
  List<Float32List> dco_decode_list_list_prim_f_32_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>)
        .map(dco_decode_list_prim_f_32_strict)
        .toList();
  }

  @protected
  List<double> dco_decode_list_prim_f_32_loose(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as List<double>;
  }

  @protected
  Float32List dco_decode_list_prim_f_32_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Float32List;
  }

  @protected
  Uint64List dco_decode_list_prim_u_64_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeUint64List(raw);
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  (
    Uint64List,
    Float32List
  ) dco_decode_record_list_prim_u_64_strict_list_prim_f_32_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2) {
      throw Exception('Expected 2 elements, got ${arr.length}');
    }
    return (
      dco_decode_list_prim_u_64_strict(arr[0]),
      dco_decode_list_prim_f_32_strict(arr[1]),
    );
  }

  @protected
  (BigInt, BigInt, BigInt, BigInt, BigInt)
      dco_decode_record_usize_usize_usize_usize_usize(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 5) {
      throw Exception('Expected 5 elements, got ${arr.length}');
    }
    return (
      dco_decode_usize(arr[0]),
      dco_decode_usize(arr[1]),
      dco_decode_usize(arr[2]),
      dco_decode_usize(arr[3]),
      dco_decode_usize(arr[4]),
    );
  }

  @protected
  BigInt dco_decode_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  BigInt dco_decode_usize(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  double sse_decode_f_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getFloat32();
  }

  @protected
  List<Float32List> sse_decode_list_list_prim_f_32_strict(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <Float32List>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_list_prim_f_32_strict(deserializer));
    }
    return ans_;
  }

  @protected
  List<double> sse_decode_list_prim_f_32_loose(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getFloat32List(len_);
  }

  @protected
  Float32List sse_decode_list_prim_f_32_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getFloat32List(len_);
  }

  @protected
  Uint64List sse_decode_list_prim_u_64_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint64List(len_);
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  (Uint64List, Float32List)
      sse_decode_record_list_prim_u_64_strict_list_prim_f_32_strict(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_field0 = sse_decode_list_prim_u_64_strict(deserializer);
    var var_field1 = sse_decode_list_prim_f_32_strict(deserializer);
    return (var_field0, var_field1);
  }

  @protected
  (BigInt, BigInt, BigInt, BigInt, BigInt)
      sse_decode_record_usize_usize_usize_usize_usize(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_field0 = sse_decode_usize(deserializer);
    var var_field1 = sse_decode_usize(deserializer);
    var var_field2 = sse_decode_usize(deserializer);
    var var_field3 = sse_decode_usize(deserializer);
    var var_field4 = sse_decode_usize(deserializer);
    return (var_field0, var_field1, var_field2, var_field3, var_field4);
  }

  @protected
  BigInt sse_decode_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_f_32(double self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putFloat32(self);
  }

  @protected
  void sse_encode_list_list_prim_f_32_strict(
      List<Float32List> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_list_prim_f_32_strict(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_f_32_loose(
      List<double> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putFloat32List(
        self is Float32List ? self : Float32List.fromList(self));
  }

  @protected
  void sse_encode_list_prim_f_32_strict(
      Float32List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putFloat32List(self);
  }

  @protected
  void sse_encode_list_prim_u_64_strict(
      Uint64List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint64List(self);
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_record_list_prim_u_64_strict_list_prim_f_32_strict(
      (Uint64List, Float32List) self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_64_strict(self.$1, serializer);
    sse_encode_list_prim_f_32_strict(self.$2, serializer);
  }

  @protected
  void sse_encode_record_usize_usize_usize_usize_usize(
      (BigInt, BigInt, BigInt, BigInt, BigInt) self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(self.$1, serializer);
    sse_encode_usize(self.$2, serializer);
    sse_encode_usize(self.$3, serializer);
    sse_encode_usize(self.$4, serializer);
    sse_encode_usize(self.$5, serializer);
  }

  @protected
  void sse_encode_u_64(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }
}