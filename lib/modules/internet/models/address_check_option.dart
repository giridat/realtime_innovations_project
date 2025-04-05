import 'dart:io';

import 'default.dart';

/// This class should be pretty self-explanatory.
/// It takes [InternetAddress] and [int] for [port] and [Duration] for [timeout]
/// which then uses [CheckInternet] to check if the address is reachable.

class AddressCheckOptions {
  /// In constructor for AddressCheckOptions. Set default [port] and [timeout].
  /// So, that while creating instance if [port] or [timeout] is not set,
  /// it will be set to default values.
  AddressCheckOptions(
    this.address, {
    this.port = DefaultValues.defaultPort,
    this.timeout = DefaultValues.defaultTimeout,
  });

  /// This the address to check for a connection.
  final InternetAddress address;

  /// This is the port to use when checking for a connection.
  final int port;

  /// Timeout is used to determine the amount of time to wait for a connection
  /// to be established before considering the connection to have failed.
  final Duration timeout;

  @override
  String toString() => 'AddressCheckOptions($address, $port, $timeout)';
}
