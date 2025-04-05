part of 'employees_bloc.dart';

sealed class EmployeesState {}

@freezed
abstract class Navigating extends EmployeesState with _$Navigating {
  factory Navigating() = _Navigating;
  Navigating._();
}

@freezed
abstract class Navigated extends EmployeesState with _$Navigated {
  factory Navigated(EmployeeDetailsViewModel? model) = _Navigated;
  Navigated._();

  @override
  EmployeeDetailsViewModel? get model => (this).model;
}

@freezed
abstract class InitialEmployeesState extends EmployeesState
    with _$InitialEmployeesState {
  factory InitialEmployeesState() = _InitialEmployeesState;
  InitialEmployeesState._();
}

@freezed
abstract class GettingEmployeesState extends EmployeesState
    with _$GettingEmployeesState {
  factory GettingEmployeesState() = _GettingEmployeesState;
  GettingEmployeesState._();
}

@freezed
abstract class GotEmployeesState extends EmployeesState with _$GotEmployeesState {
  factory GotEmployeesState(
          {required List<EmployeeDetailsViewModel> currentEmployees,
          required List<EmployeeDetailsViewModel> previousEmployees}) =
      _GotEmployeesState;
  GotEmployeesState._();
  @override
  List<EmployeeDetailsViewModel> get currentEmployees =>
      (this).currentEmployees;
  @override
  List<EmployeeDetailsViewModel> get previousEmployees =>
      (this).previousEmployees;
}

@freezed
abstract class ErrorGettingEmployeesState extends EmployeesState
    with _$ErrorGettingEmployeesState {
  factory ErrorGettingEmployeesState({required String errorMessage}) =
      _ErrorGettingEmployeesState;
  ErrorGettingEmployeesState._();
  @override
  String get errorMessage => (this).errorMessage;
}

@freezed
abstract class AddingEmployeeState extends EmployeesState with _$AddingEmployeeState {
  factory AddingEmployeeState() = _AddingEmployeeState;
  AddingEmployeeState._();
}

@freezed
abstract class AddedEmployeeState extends EmployeesState with _$AddedEmployeeState {
  factory AddedEmployeeState() = _AddedEmployeeState;
  AddedEmployeeState._();
}

@freezed
abstract class ErrorAddingEmployeeState extends EmployeesState
    with _$ErrorAddingEmployeeState {
  factory ErrorAddingEmployeeState({required String errorMessage}) =
      _ErrorAddingEmployeeState;
  ErrorAddingEmployeeState._();

  @override
  String get errorMessage => (this).errorMessage;
}

@freezed
abstract class UpdatingEmployeeState extends EmployeesState
    with _$UpdatingEmployeeState {
  factory UpdatingEmployeeState() = _UpdatingEmployeeState;
  UpdatingEmployeeState._();
}

@freezed
abstract class UpdatedEmployeeState extends EmployeesState with _$UpdatedEmployeeState {
  factory UpdatedEmployeeState() = _UpdatedEmployeeState;
  UpdatedEmployeeState._();
}

@freezed
abstract class ErrorUpdatingEmployeeState extends EmployeesState
    with _$ErrorUpdatingEmployeeState {
  factory ErrorUpdatingEmployeeState({required String errorMessage}) =
      _ErrorUpdatingEmployeeState;
  ErrorUpdatingEmployeeState._();

  @override
  String get errorMessage => (this).errorMessage;
}

@freezed
abstract class DeletingEmployeeState extends EmployeesState
    with _$DeletingEmployeeState {
  factory DeletingEmployeeState() = _DeletingEmployeeState;

  DeletingEmployeeState._();
}

@freezed
abstract class DeletedEmployeeState extends EmployeesState with _$DeletedEmployeeState {
  factory DeletedEmployeeState(
          {required EmployeeDetailsViewModel deletedEmployee}) =
      _DeletedEmployeeState;
  DeletedEmployeeState._();
  @override
  EmployeeDetailsViewModel get deletedEmployee => (this).deletedEmployee;
}

@freezed
abstract class RestoringDeletedEmployeeState extends EmployeesState
    with _$RestoringDeletedEmployeeState {
  factory RestoringDeletedEmployeeState() = _RestoringDeletedEmployeeState;
  RestoringDeletedEmployeeState._();
}

@freezed
abstract class RestoredDeletedEmployeeState extends EmployeesState
    with _$RestoredDeletedEmployeeState {
  factory RestoredDeletedEmployeeState() = _RestoredDeletedEmployeeState;
  RestoredDeletedEmployeeState._();
}

@freezed
abstract class ErrorDeletingEmployeeState extends EmployeesState
    with _$ErrorDeletingEmployeeState {
  factory ErrorDeletingEmployeeState({required String errorMessage}) =
      _ErrorDeletingEmployeeState;
  ErrorDeletingEmployeeState._();

  @override
  String get errorMessage => (this).errorMessage;
}

@freezed
abstract class CreateNameInputFieldState extends EmployeesState
    with _$CreateNameInputFieldState {
  factory CreateNameInputFieldState(
          {required AddUpdateEmployeeDetailsForm form}) =
      _CreateNameInputFieldState;
  CreateNameInputFieldState._();
  @override
  AddUpdateEmployeeDetailsForm get form => (this).form;
}

@freezed
abstract class ValidateNameInputFieldState extends EmployeesState
    with _$ValidateNameInputFieldState {
  factory ValidateNameInputFieldState(
          {required AddUpdateEmployeeDetailsForm form}) =
      _ValidateNameInputFieldState;
  ValidateNameInputFieldState._();
  @override
  AddUpdateEmployeeDetailsForm get form => (this).form;
}

@freezed
abstract class SettingRole extends EmployeesState with _$SettingRole {
  factory SettingRole() = _SettingRole;
  SettingRole._();
}

@freezed
abstract class RoleSetSuccessfully extends EmployeesState with _$RoleSetSuccessfully {
  factory RoleSetSuccessfully(String role) = _RoleSetSuccessfully;
  RoleSetSuccessfully._();
  @override
  String get role => (this).role;
}

@freezed
abstract class SelectingStartDate extends EmployeesState with _$SelectingStartDate {
  factory SelectingStartDate() = _SelectingStartDate;
  SelectingStartDate._();
}

@freezed
abstract class StartDateSelected extends EmployeesState with _$StartDateSelected {
  factory StartDateSelected({required DateTime startDate}) = _StartDateSelected;

  StartDateSelected._();
  @override
  DateTime get startDate => (this).startDate;
}

@freezed
abstract class SelectingEndDate extends EmployeesState with _$SelectingEndDate {
  factory SelectingEndDate() = _SelectingEndDate;
  SelectingEndDate._();
}

@freezed
abstract class EndDateSelected extends EmployeesState with _$EndDateSelected {
  factory EndDateSelected({DateTime? endDate}) = _EndDateSelected;
  EndDateSelected._();
  @override
  DateTime? get endDate => (this).endDate;
}

@freezed
abstract class CheckingFormState extends EmployeesState with _$CheckingFormState {
  factory CheckingFormState() = _CheckingFormState;
  CheckingFormState._();
}

@freezed
abstract class FormValidatedSuccessfully extends EmployeesState
    with _$FormValidatedSuccessfully {
  factory FormValidatedSuccessfully() = _FormValidatedSuccessfully;
  FormValidatedSuccessfully._();
}

@freezed
abstract class ErrorValidatingFormState extends EmployeesState
    with _$ErrorValidatingFormState {
  factory ErrorValidatingFormState() = _ErrorValidatingFormState;

  ErrorValidatingFormState._();
}
