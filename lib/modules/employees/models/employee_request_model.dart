import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';

part 'employee_request_model.freezed.dart';

part 'employee_request_model.g.dart';

@Freezed(fromJson: false, toJson: true)
class EmployeeRequestModel with _$EmployeeRequestModel {
   factory EmployeeRequestModel({
    required EmployeeDetailsViewModel employeeDetails,
  }) = _EmployeeRequestModel;
  EmployeeRequestModel._();

  @override
  EmployeeDetailsViewModel get employeeDetails => (this).employeeDetails;

  @override
  Map<String, dynamic> toJson() => (this).toJson();
}
