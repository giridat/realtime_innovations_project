import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/userflow_enums.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure implements Exception {
  factory Failure.fromErrorObject(
    Object error, {
    required UserFlowEnums userFlow,
  }) {
    if (error is FirebaseException) {
      if (kDebugMode) {
        debugPrint('FirebaseException -----> $error');
      }

      return Failure.def(
        message: error.message ?? 'An unknown Firebase error occurred',
        errorCode: error.code,
        plugin: error.plugin,
      );
    }

    if (error is PlatformException) {
      if (kDebugMode) {
        debugPrint('PlatformException -----> $error');
      }

      return Failure.def(
        message: error.message ?? 'A platform error occurred with Firebase',
        errorCode: error.code,
      );
    }

    return Failure.def(
      message: 'An unknown error occurred',
    );
  }

  Failure._();

  factory Failure.def({
    required String message,
    String? errorCode,
    String? plugin,
  }) = _Failure;

  @override
  List<DiagnosticsNode> debugDescribeChildren() =>
      (this).debugDescribeChildren();

  @override
  String? get errorCode => (this).errorCode;

  @override
  String get message => (this).message;

  @override
  String? get plugin => (this).plugin;

  @override
  DiagnosticsNode toDiagnosticsNode(
          {String? name, DiagnosticsTreeStyle? style}) =>
      (this).toDiagnosticsNode(name: name, style: style);

  @override
  String toStringDeep(
          {String prefixLineOne = '',
          String? prefixOtherLines,
          DiagnosticLevel minLevel = DiagnosticLevel.debug,
          int wrapWidth = 65}) =>
      (this).toStringDeep(
          prefixLineOne: prefixLineOne,
          prefixOtherLines: prefixOtherLines,
          minLevel: minLevel,
          wrapWidth: wrapWidth);

  @override
  String toStringShallow(
          {String joiner = ', ',
          DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      (this).toStringShallow(joiner: joiner, minLevel: minLevel);

  @override
  String toStringShort() => (this).toStringShort();
}
