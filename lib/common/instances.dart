import 'package:flutter/material.dart';
import 'package:realtime_innovations_project/modules/employees/repo/employees_repo.dart';
import 'package:realtime_innovations_project/modules/internet/bloc/internet_bloc.dart';
import 'package:realtime_innovations_project/services_config/api_services.dart';
import 'package:realtime_innovations_project/services_config/firebase_services.dart';

class Instance {
  static final scaffoldMessengerState = GlobalKey<ScaffoldMessengerState>();
  static final scaffoldState = GlobalKey<ScaffoldState>();
  static final theme = ThemeData();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final navigator = Navigator.of(navigatorKey.currentContext!);
  static final apiServices = ApiServices();
  static EmployeesRepo employeesRepo = EmployeesRepo();
  static FirebaseService firebaseService = FirebaseService();
  static InternetBloc internetBloc = InternetBloc();
}
