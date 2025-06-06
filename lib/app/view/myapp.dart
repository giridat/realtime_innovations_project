import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realtime_innovations_project/bootstrap.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/modules/employees/bloc/employees_bloc.dart';
import 'package:realtime_innovations_project/modules/employees/view/employees_main.dart';
import 'package:realtime_innovations_project/modules/internet/bloc/internet_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return !kIsWeb?BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        key: Instance.scaffoldState,
        navigatorObservers: [RouteObserverService()],
        navigatorKey: Instance.navigatorKey,
        title: 'Realtime Innovations Project',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 16),
            bodySmall: TextStyle(fontSize: 14),
          ),
        ),
        home: BlocProvider(
          create: (context) => EmployeesBloc()..add(GetEmployees()),
          child: EmployeesMain(),
        ),
      ),
    ):MaterialApp(
      debugShowCheckedModeBanner: false,
      key: Instance.scaffoldState,
      navigatorObservers: [RouteObserverService()],
      navigatorKey: Instance.navigatorKey,
      title: 'Realtime Innovations Project',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 14),
        ),
      ),
      home: BlocProvider(
        create: (context) => EmployeesBloc()..add(GetEmployees()),
        child: EmployeesMain(),
      ),
    );
  }
}
