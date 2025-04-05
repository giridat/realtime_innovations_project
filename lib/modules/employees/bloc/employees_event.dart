part of 'employees_bloc.dart';

sealed class EmployeesEvent {}

@freezed
abstract class Navigate extends EmployeesEvent with _$Navigate {
  factory Navigate({String? id}) = _Navigate;
  Navigate._();

  @override
  String? get id => (this).id;
}

@freezed
abstract class GetEmployees extends EmployeesEvent with _$GetEmployees {
  factory GetEmployees() = _GetEmployees;
  GetEmployees._();
}

@freezed
abstract class DeleteEmployee extends EmployeesEvent with _$DeleteEmployee {
  factory DeleteEmployee({required String id}) = _DeleteEmployee;
  DeleteEmployee._();

  @override
  String get id => (this).id;
}

@freezed
abstract class UpdateEmployee extends EmployeesEvent with _$UpdateEmployee {
  factory UpdateEmployee({required EmployeeRequestModel employee}) =
      _UpdateEmployee;
  UpdateEmployee._();
  @override
  EmployeeRequestModel get employee => (this).employee;
}

@freezed
abstract class AddEmployee extends EmployeesEvent with _$AddEmployee {
  factory AddEmployee() = _AddEmployee;
  AddEmployee._();
}

@freezed
abstract class OnNameFieldChanged extends EmployeesEvent with _$OnNameFieldChanged {
  factory OnNameFieldChanged({required AddUpdateEmployeeDetailsForm name}) =
      _OnNameFieldChanged;
  OnNameFieldChanged._();
  @override
  AddUpdateEmployeeDetailsForm get name => (this).name;
}

@freezed
abstract class SetRoleEvent extends EmployeesEvent with _$SetRoleEvent {
  factory SetRoleEvent({required String role}) = _SetRoleEvent;
  SetRoleEvent._();
  @override
  String get role => (this).role;
}

@freezed
abstract class OnStartDateSelected extends EmployeesEvent with _$OnStartDateSelected {
  factory OnStartDateSelected({required DateTime startDate}) =
      _OnStartDateSelected;
  OnStartDateSelected._();
  @override
  DateTime get startDate => (this).startDate;
}

@freezed
abstract class OnEndDateSelected extends EmployeesEvent with _$OnEndDateSelected {
  factory OnEndDateSelected({DateTime? endDate}) = _OnEndDateSelected;
  OnEndDateSelected._();
  @override
  DateTime? get endDate => (this).endDate;
}

@freezed
abstract class MarkFormCompleted extends EmployeesEvent with _$MarkFormCompleted {
  factory MarkFormCompleted() = _MarkFormCompleted;
  MarkFormCompleted._();
}

@freezed
abstract class RestoreDeletedEmployee extends EmployeesEvent
    with _$RestoreDeletedEmployee {
  factory RestoreDeletedEmployee() = _RestoreDeletedEmployee;

  RestoreDeletedEmployee._();
}
