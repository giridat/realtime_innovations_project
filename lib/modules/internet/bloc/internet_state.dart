part of 'internet_bloc.dart';

sealed class InternetState {}

@freezed
class InternetInitial extends InternetState with _$InternetInitial {
   factory InternetInitial() = _InternetInitial;
  InternetInitial._();
}

@freezed
class CheckingInternet extends InternetState with _$CheckingInternet {
   factory CheckingInternet() = _CheckingInternet;
  CheckingInternet._();
}

@freezed
class InternetConnected extends InternetState with _$InternetConnected {
   factory InternetConnected() = _InternetConnected;
  InternetConnected._();
}

@freezed
class InternetDisconnected extends InternetState with _$InternetDisconnected {
   factory InternetDisconnected() = _InternetDisconnected;
  InternetDisconnected._();
}

@freezed
class InternetAvailable extends InternetState with _$InternetAvailable {
   factory InternetAvailable() = _InternetAvailable;
  InternetAvailable._();
}

@freezed
class InternetUnavailable extends InternetState with _$InternetUnavailable {
   factory InternetUnavailable() = _InternetUnavailable;
  InternetUnavailable._();
}
