import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:realtime_innovations_project/hive_registrar.g.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';
import 'package:realtime_innovations_project/services_config/local_db/hive/hive_types.dart';

import 'common/instances.dart';
import 'firebase_options.dart';
import 'modules/internet/bloc/internet_bloc.dart';
import 'modules/internet/view/no_internet_screen.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({this.showVerbose = false});

  final bool showVerbose;

  // Function to remove prefix and suffix
  String formatStateName(String stateType) {
    return stateType.replaceAll(r'_$', '').replaceAll('Impl', '');
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    final formattedBlocType = formatStateName(bloc.runtimeType.toString());
    final logMessage = 'onCreate: $formattedBlocType';

    if (showVerbose) {
      log('$logMessage\nDetails: ${bloc.runtimeType}', name: formattedBlocType);
    } else {
      log(logMessage, name: formattedBlocType);
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    final formattedBlocType = formatStateName(bloc.runtimeType.toString());
    final logMessage =
        'onTransition: $formattedBlocType, event: ${transition.event.runtimeType}';

    if (showVerbose) {
      log(
        '$logMessage\nEvent Data: ${transition.event}\nFrom: ${transition.currentState}\nTo: ${transition.nextState}',
        name: formattedBlocType,
      );
    } else {
      log(logMessage, name: formattedBlocType);
    }
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    final formattedBlocType = formatStateName(bloc.runtimeType.toString());
    final formattedEventType = event != null
        ? formatStateName(event.runtimeType.toString())
        : 'UnknownEvent';
    final logMessage =
        'onEvent: $formattedBlocType, event: $formattedEventType';

    if (showVerbose) {
      log('$logMessage\nEvent Data: $event', name: formattedBlocType);
    } else {
      log(logMessage, name: formattedBlocType);
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final previousStateType = change.currentState;
    final nextStateType = change.nextState;
    if (previousStateType == null || nextStateType == null) {
      log(
        'onChange(${bloc.runtimeType}, $change)',
        stackTrace: StackTrace.current,
      );
      return;
    }

    final formattedPreviousState =
        formatStateName(previousStateType.runtimeType.toString());
    final formattedNextState =
        formatStateName(nextStateType.runtimeType.toString());
    final logMessage =
        'previous: $formattedPreviousState, next: $formattedNextState';

    if (showVerbose) {
      log(
        '$logMessage\nFrom: ${change.currentState}\nTo: ${change.nextState}\nDetails: $change',
        name: '${bloc.runtimeType}',
      );
    } else {
      log(logMessage, name: '${bloc.runtimeType}');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

class RouteObserverService extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    currentRoute = route.settings.name;
    log("Current Route: $currentRoute");
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    currentRoute = previousRoute?.settings.name;
    log("Current Route: $currentRoute");
    super.didPop(route, previousRoute);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFirebase =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = const AppBlocObserver();
  // await rootBundle.load('.env');
  // await dotenv.load();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  await Hive.initFlutter();

  Hive.registerAdapters();

  await Future.wait([Hive.openBox<EmployeeDetailsViewModel>(HiveTypes.employeeBox), initFirebase]);

  runApp(await builder());

  if (kIsWeb) {
    final StreamSubscription<InternetState> internetSubscription;

    void handleInternetStateChange(InternetState state) {
      switch (state) {
        case InternetDisconnected():
          Instance.navigatorKey.currentState!.push(
            MaterialPageRoute<void>(
              settings: const RouteSettings(name: '/no-internet'),
              builder: (context) => const NoInternetScreen(),
            ),
          );
        case InternetAvailable():
          final canPop = Instance.navigatorKey.currentState!.canPop();
          if (canPop == true &&
              Instance.navigatorKey.currentWidget.toString() == '/no-internet') {
            Instance.navigatorKey.currentState!.pop();
          }

        case InternetConnected():
          final canPop = Instance.navigatorKey.currentState!.canPop();
          if (canPop == true &&
              Instance.navigatorKey.currentWidget.toString() == '/no-internet') {
            Instance.navigatorKey.currentState!.pop();
          }

        default:
          break;
      }
    }

    internetSubscription = Instance.internetBloc.stream.listen(
      handleInternetStateChange,
    );
  }
}
