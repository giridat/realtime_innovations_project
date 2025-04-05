part of 'internet_bloc.dart';

sealed class InternetEvent {}

@freezed
class InternetStatusChanged extends InternetEvent with _$InternetStatusChanged {
  factory InternetStatusChanged.statusChanged({
    required InternetStatus status,
  }) = _StatusChanged;
  InternetStatusChanged._();

  @override
  InternetStatus get status => (this).status;
}

@freezed
class CheckInternetConnectivity extends InternetEvent
    with _$CheckInternetConnectivity {
  factory CheckInternetConnectivity() = _CheckInternetConnectivity;
  CheckInternetConnectivity._();
}
