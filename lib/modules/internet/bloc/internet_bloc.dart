import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/modules/internet/constants/internet_status.dart';
import 'package:realtime_innovations_project/modules/internet/src/check_internet_status.dart';

part 'internet_event.dart';
part 'internet_state.dart';

part 'internet_bloc.freezed.dart';
class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super( InternetInitial()) {
    // Initial setup
    _checkInternet =
        CheckInternetStatus(waitOnConnectedStatusInMicroseconds: 500000);

    // Setup event handlers
    on<InternetStatusChanged>(_onStatusChanged);
    on<CheckInternetConnectivity>(_onCheckConnectivity);

    // Setup listeners on the repo
    _setupInternetRepoListener();
  }

  void _setupInternetRepoListener() {
    _checkInternet.onStatusChange.listen((status) {
      if (isClosed) {
        return;
      }
      add(_StatusChanged(status: status));
    });
  }

  Future<void> _onStatusChanged(
    InternetStatusChanged event,
    Emitter<InternetState> emit,
  ) async {
    switch (event.status) {
      case InternetStatus.disconnected:
        emit( InternetDisconnected());
      case InternetStatus.checking:
        emit( CheckingInternet());
      case InternetStatus.connected:
        emit( InternetConnected());
        final canPop = Instance.navigatorKey.currentState!.canPop();
        if (canPop == true && Instance.navigatorKey.currentWidget.toString() == '/no-internet') {
          Instance.navigatorKey.currentState!.pop();
        }
      case InternetStatus.unavailable:
        emit( InternetUnavailable());
      case InternetStatus.available:
        emit( InternetAvailable());

        final canPop = Instance.navigatorKey.currentState!.canPop();

        if (canPop == true && Instance.navigatorKey.currentWidget.toString() == '/no-internet') {
          Instance.navigatorKey.currentState!.pop();
        }
    }
  }

  Future<void> _onCheckConnectivity(
    CheckInternetConnectivity event,
    Emitter<InternetState> emit,
  ) async {
    await _checkInternet.checkConnectivity();
  }

  @override
  Future<void> close() async {
    _checkInternet.dispose();
    return super.close();
  }

  @override
  Future<void> dispose() async {
    await close();
  }

  late final CheckInternetStatus _checkInternet;
}
