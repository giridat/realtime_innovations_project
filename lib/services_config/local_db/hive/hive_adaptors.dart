
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';


part 'hive_adaptors.g.dart';



@GenerateAdapters([
  AdapterSpec<EmployeeDetailsViewModel>(),
])

class HiveAdaptors {}

