import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:realtime_innovations_project/modules/internet/constants/internet_status.dart';

import 'check_internet.dart';

/// Current internet status.
/// This class will expose stream of current internet status.
/// which can be used to listen to the status changes of the internet.
class CheckInternetStatus {
  /// Constructor of the [CheckInternetStatus] class.
  CheckInternetStatus({required this.waitOnConnectedStatusInMicroseconds})
      : _connectivity = Connectivity(),
        _checkInternet = CheckInternet(),
        _currentInternetStatus = StreamController<InternetStatus>.broadcast() {
    _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  /// This is the [Connectivity] instance that is used to check
  /// if wifi or mobile data is switched on.
  late final Connectivity _connectivity;

  /// This is the [CheckInternet] instance that is used to check
  ///  if wifi or mobile data is switched on then if the Internet is available
  /// or not. It is initialized in the constructor.
  late final CheckInternet _checkInternet;

  /// No of microsecond to wait before change the status from connected
  /// to available It's useful incase connection status is connected and
  /// then you want to show user something or do something before status changes
  ///  to available then its useful to put wait time else suggested to pass 0
  final int waitOnConnectedStatusInMicroseconds;

  /// Stream controller of the current internet status.
  late final StreamController<InternetStatus> _currentInternetStatus;

  /// timer that will be used to change the status from connected to available
  /// after the [waitOnConnectedStatusInMicroseconds] seconds.
  Timer? _timer;

  /// This is the method _handleConnectivityChange that will receive the
  /// [ConnectivityResult] and will check if the [ConnectivityResult] is
  /// [ConnectivityResult.wifi] or [ConnectivityResult.mobile].
  /// If the [ConnectivityResult] is [ConnectivityResult.wifi] or
  /// [ConnectivityResult.mobile], we will check if
  /// the internet is available or not.
  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> connectivityResult,
  ) async {
    /// cancel the timer if it is running
    _timer?.cancel();

    //  _currentInternetStatus.add(InternetStatus.checking);
    /// Here we check if the [ConnectivityResult] is
    ///  [ConnectivityResult.wifi] or [ConnectivityResult.mobile].
    final isDataOn = connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile);
    if (isDataOn) {
      final isDeviceConnected = await _checkInternet.hasConnection;
      if (isDeviceConnected) {
        /// If the device is connected to the Internet, we emit the
        /// [InternetConnectionState.connected] state.
        _currentInternetStatus.add(InternetStatus.connected);
        _timer = Timer(
          Duration(microseconds: waitOnConnectedStatusInMicroseconds),
          () async {
            _currentInternetStatus.add(InternetStatus.available);
          },
        );
        return;
      }
      _currentInternetStatus.add(InternetStatus.unavailable);
      return;
    }
    _currentInternetStatus.add(InternetStatus.disconnected);
    return;
  }

  // first check then explicitly call the checkConnectivity method
  // to get the current status of the internet. This is done to avoid
  // the delay in the first time when the app is opened.
  Future<void> checkConnectivity() async {
    await _connectivity.checkConnectivity().then(_handleConnectivityChange);
  }

  /// Stream of the current internet status.
  Stream<InternetStatus> get onStatusChange => _currentInternetStatus.stream;

  /// bool that store if there is any listener attached to the
  ///  [onStatusChange] stream.
  bool get hasListeners => _currentInternetStatus.hasListener;

  /// This will close the stream of the current internet status.
  void dispose() {
    _currentInternetStatus.close();
    if (!_checkInternet.hasListeners) {
      _checkInternet.dispose();
    }
    _timer?.cancel();
  }
}
