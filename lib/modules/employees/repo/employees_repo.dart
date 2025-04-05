import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:realtime_innovations_project/common/failure.dart';
import 'package:realtime_innovations_project/common/firebase_collections.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/common/repo_type.dart';
import 'package:realtime_innovations_project/modules/employees/models/add_update_employee_details_form.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_request_model.dart';

part 'employees_repo.freezed.dart';

@freezed
class EmployeesRepo extends Repo with _$EmployeesRepo {
  factory EmployeesRepo({
    List<EmployeeDetailsViewModel>? currentEmployeeList,
    List<EmployeeDetailsViewModel>? previousEmployeeList,
    AddUpdateEmployeeDetailsForm? addUpdateEmployeeDetailsForm,
    EmployeeRequestModel? employeeRequestModel,
    EmployeeDetailsViewModel? selectedEmployeeDetailsViewModel,
    EmployeeDetailsViewModel? deletedEmployeeDetailsViewModel,
    @Default(false) bool? isFormComplete,
  }) = _EmployeesRepo;

  EmployeesRepo._();

  Future<Either<Failure, List<EmployeeDetailsViewModel>>?>
      getCurrentEmployeeList() async {
    try {
      final response = await Instance.firebaseService.getDocumentsList(
          collectionName: FirebaseCollections.employeesCollection);
      final data = response
          .map((e) => EmployeeDetailsViewModel.fromJson(
              e.data() as Map<String, dynamic>))
          .toList();
      return Right(data);
    } catch (e, ex) {
      return Left(Failure.def(message: "Error getting employees + $e \n $ex"));
    }
  }

  Future<Either<Failure, List<EmployeeDetailsViewModel>>?>
      getPreviousEmployeeList() async {}

  Future<Either<Failure, bool>> addEmployee(
      EmployeeRequestModel employeeRequestModel) async {
    try {
      final response = await Instance.firebaseService.createDocument(
          collectionName: FirebaseCollections.employeesCollection,
          documentId: employeeRequestModel.employeeDetails.id,
          data: employeeRequestModel.employeeDetails.toJson());
      if (response == false) {
        return Left(Failure.def(message: "Error adding employee "));
      } else {
        return Right(true);
      }
    } catch (e, ex) {
      return Left(Failure.def(message: "Error adding employee + $e \n $ex"));
    }
  }

  Future<Either<Failure, EmployeeDetailsViewModel>> updateEmployee(
      EmployeeRequestModel employeeRequestModel) async {
    try {
      final response = await Instance.firebaseService.updateDocument(
          collectionName: FirebaseCollections.employeesCollection,
          documentId: employeeRequestModel.employeeDetails.id,
          data: employeeRequestModel.employeeDetails.toJson());
      if (response == false) {
        return Left(Failure.def(message: "Error updating employee "));
      } else {
        final newModel = await Instance.firebaseService.getDocument(
          collectionName: FirebaseCollections.employeesCollection,
          documentId: employeeRequestModel.employeeDetails.id,
        );
        if (newModel == null) {
          return Left(Failure.def(message: "Failed to get updated model "));
        }
        final updatedModel = EmployeeDetailsViewModel.fromJson(newModel);
        return Right(updatedModel);
      }
    } catch (e, ex) {
      return Left(Failure.def(message: "Error updating employee + $e \n $ex"));
    }
  }

  Future<Either<Failure, bool>> deleteEmployee(String id) async {
    final response = await Instance.firebaseService.deleteDocument(
        collectionName: FirebaseCollections.employeesCollection,
        documentId: id);
    if (response == false) {
      return Left(Failure.def(message: "Error deleting employee "));
    }

    return Right(true);
  }

  @override
  List<EmployeeDetailsViewModel>? get currentEmployeeList =>
      (this).currentEmployeeList;

  @override
  List<EmployeeDetailsViewModel>? get previousEmployeeList =>
      (this).previousEmployeeList;
  @override
  EmployeeRequestModel? get employeeRequestModel => (this).employeeRequestModel;

  @override
  EmployeeDetailsViewModel? get selectedEmployeeDetailsViewModel =>
      (this).selectedEmployeeDetailsViewModel;
  @override
  AddUpdateEmployeeDetailsForm? get addUpdateEmployeeDetailsForm =>
      (this).addUpdateEmployeeDetailsForm;

  @override
  bool? get isFormComplete => (this).isFormComplete;

  @override
  EmployeeDetailsViewModel? get deletedEmployeeDetailsViewModel =>
      (this).deletedEmployeeDetailsViewModel;
}
