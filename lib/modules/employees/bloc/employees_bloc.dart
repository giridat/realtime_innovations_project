import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/modules/employees/models/add_update_employee_details_form.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_request_model.dart';
import 'package:realtime_innovations_project/modules/employees/models/name_input_field_model_value.dart';
import 'package:realtime_innovations_project/modules/internet/bloc/internet_bloc.dart';
import 'package:realtime_innovations_project/services_config/local_db/hive/hive_types.dart';
import 'package:uuid/uuid.dart';

part 'employees_event.dart';
part 'employees_state.dart';
part 'employees_bloc.freezed.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  EmployeesBloc() : super(InitialEmployeesState()) {
    on<GetEmployees>(_getEmployees);
    on<Navigate>(_navigateTo);
    on<AddEmployee>(_addEmployee);
    on<UpdateEmployee>(_updateEmployee);
    on<DeleteEmployee>(_deleteEmployee);
    on<OnStartDateSelected>(_onStartDateSelected);
    on<OnEndDateSelected>(_onEndDateSelected);
    on<OnNameFieldChanged>(_onNameFieldChanged);
    on<SetRoleEvent>(_setRoleEvent);
    on<MarkFormCompleted>(_markFormCompleted);
    on<RestoreDeletedEmployee>(_restoreDeletedEmployee);
  }
  FutureOr<void> _restoreDeletedEmployee(
    RestoreDeletedEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(RestoringDeletedEmployeeState());

    final deletedModel = Instance.employeesRepo.deletedEmployeeDetailsViewModel;
    if (deletedModel == null) return;

    final employee = EmployeeRequestModel(employeeDetails: deletedModel);
    final response = await Instance.employeesRepo.addEmployee(employee);

    final data = response.fold<bool>((l) {
      emit(ErrorDeletingEmployeeState(
          errorMessage: "Error restoring deleted employee ${l.toString()}"));
      return false;
    }, (r) => r);

    if (data == false) {
      emit(ErrorDeletingEmployeeState(
          errorMessage: "Error restoring deleted employee"));
      return;
    }

    final existingCurrentList = [
      ...?Instance.employeesRepo.currentEmployeeList
    ];
    final existingPreviousList = [
      ...?Instance.employeesRepo.previousEmployeeList
    ];

    if (deletedModel.endDate.isEmpty) {
      final newCurrentList = [deletedModel, ...existingCurrentList];
      Instance.employeesRepo = Instance.employeesRepo.copyWith(
        currentEmployeeList: newCurrentList,
        previousEmployeeList: existingPreviousList,
      );
    } else {
      final newPreviousList = [deletedModel, ...existingPreviousList];
      Instance.employeesRepo = Instance.employeesRepo.copyWith(
        currentEmployeeList: existingCurrentList,
        previousEmployeeList: newPreviousList,
      );
    }

    final box = Hive.box<EmployeeDetailsViewModel>(HiveTypes.employeeBox);
    box.put(deletedModel.id, deletedModel);

    Instance.employeesRepo = Instance.employeesRepo.copyWith(
      deletedEmployeeDetailsViewModel: null,
    );

    emit(RestoredDeletedEmployeeState());
  }

  FutureOr<void> _markFormCompleted(
      MarkFormCompleted event, Emitter<EmployeesState> emit) async {
    emit(CheckingFormState());
    final currentModel =
        Instance.employeesRepo.selectedEmployeeDetailsViewModel;
    if (currentModel != null &&
        currentModel.name.isNotEmpty &&
        currentModel.startDate.isNotEmpty) {
      Instance.employeesRepo =
          Instance.employeesRepo.copyWith(isFormComplete: true);
      emit(FormValidatedSuccessfully());
    } else {
      Instance.employeesRepo =
          Instance.employeesRepo.copyWith(isFormComplete: false);

      emit(ErrorValidatingFormState());
    }
  }

  FutureOr<void> _setRoleEvent(
      SetRoleEvent event, Emitter<EmployeesState> emit) async {
    emit(SettingRole());
    final role = event.role;
    final currentModel = Instance.employeesRepo.selectedEmployeeDetailsViewModel
            ?.copyWith(role: role) ??
        EmployeeDetailsViewModel(
          id: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.id ??
              Uuid().v4(),
          name: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.name ??
              '',
          role: role,
          startDate: Instance
                  .employeesRepo.selectedEmployeeDetailsViewModel?.startDate ??
              '',
          endDate: Instance
                  .employeesRepo.selectedEmployeeDetailsViewModel?.endDate ??
              '',
          createdAt: Instance
                  .employeesRepo.selectedEmployeeDetailsViewModel?.createdAt ??
              DateTime.now(),
          updatedAt: Instance
                  .employeesRepo.selectedEmployeeDetailsViewModel?.updatedAt ??
              DateTime.now(),
        );

    Instance.employeesRepo = Instance.employeesRepo
        .copyWith(selectedEmployeeDetailsViewModel: currentModel);
    emit(RoleSetSuccessfully(role));
    add(MarkFormCompleted());
  }

  FutureOr<void> _onNameFieldChanged(
      OnNameFieldChanged event, Emitter<EmployeesState> emit) async {
    final name = event.name;
    final currentForm = Instance.employeesRepo.addUpdateEmployeeDetailsForm;
    final currentModel =
        Instance.employeesRepo.selectedEmployeeDetailsViewModel;

    Instance.employeesRepo = Instance.employeesRepo.copyWith(
        addUpdateEmployeeDetailsForm: currentForm?.copyWith(
              name: name.name,
            ) ??
            AddUpdateEmployeeDetailsForm(name: name.name));

    final isValid = currentForm?.isValid ?? false;
    if (!isValid) {
      emit(CreateNameInputFieldState(
          form: currentForm ??
              AddUpdateEmployeeDetailsForm(
                name: NameInputField.pure(NameInputFieldModelValue(
                    value: name.name.value.inputValue)),
              )));

      return;
    }

    Instance.employeesRepo = Instance.employeesRepo.copyWith(
        selectedEmployeeDetailsViewModel: currentModel?.copyWith(
              name: name.name.value.inputValue,
            ) ??
            EmployeeDetailsViewModel(
              id: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.id ??
                  Uuid().v4(),
              name: name.name.value.inputValue,
              role: Instance
                      .employeesRepo.selectedEmployeeDetailsViewModel?.role ??
                  '',
              startDate: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                      ?.startDate ??
                  '',
              endDate: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                      ?.endDate ??
                  '',
              updatedAt: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                      ?.updatedAt ??
                  DateTime.now(),

              createdAt: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                      ?.createdAt ??
                DateTime.now(),

            ));
    emit(ValidateNameInputFieldState(form: name));
    add(MarkFormCompleted());
  }

  FutureOr<void> _onEndDateSelected(
      OnEndDateSelected event, Emitter<EmployeesState> emit) async {
    emit(SelectingEndDate());
    final date = event.endDate;
    final currentModel = Instance.employeesRepo.selectedEmployeeDetailsViewModel
            ?.copyWith(
                endDate: date != null
                    ? DateFormat("d MMM, yyyy").format(date)
                    : '') ??
        EmployeeDetailsViewModel(
            id: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.id ??
                Uuid().v4(),
            name: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.name ??
                '',
            role: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.role ??
                '',
            startDate: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                    ?.startDate ??
                '',
            endDate: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.endDate ??
                (date != null ? DateFormat("d MMM, yyyy").format(date) : ''),
            createdAt: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                    ?.createdAt ??
                DateTime.now(),

            updatedAt:
                Instance.employeesRepo.selectedEmployeeDetailsViewModel?.updatedAt ??
                    DateTime.now(),
        );

    Instance.employeesRepo = Instance.employeesRepo
        .copyWith(selectedEmployeeDetailsViewModel: currentModel);
    emit(EndDateSelected(endDate: date));
    add(MarkFormCompleted());
  }

  FutureOr<void> _onStartDateSelected(
      OnStartDateSelected event, Emitter<EmployeesState> emit) async {
    emit(SelectingStartDate());
    final date = event.startDate;
    final currentModel = Instance.employeesRepo.selectedEmployeeDetailsViewModel
            ?.copyWith(
          startDate: DateFormat("d MMM, yyyy").format(date),
        ) ??
        EmployeeDetailsViewModel(
            id: Instance.employeesRepo.selectedEmployeeDetailsViewModel?.id ??
                Uuid().v4(),
            name:
                Instance.employeesRepo.selectedEmployeeDetailsViewModel?.name ??
                    '',
            role:
                Instance.employeesRepo.selectedEmployeeDetailsViewModel?.role ??
                    '',
            startDate: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                    ?.startDate ??
                DateFormat("d MMM, yyyy").format(date),
            endDate: Instance
                    .employeesRepo.selectedEmployeeDetailsViewModel?.endDate ??
                '',
            createdAt: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                    ?.createdAt ??
                DateTime.now(),
            updatedAt: Instance.employeesRepo.selectedEmployeeDetailsViewModel
                    ?.updatedAt ??
                DateTime.now(),
        );

    Instance.employeesRepo = Instance.employeesRepo
        .copyWith(selectedEmployeeDetailsViewModel: currentModel);
    emit(StartDateSelected(startDate: date));
    add(MarkFormCompleted());
  }

  FutureOr<void> _getEmployees(
      GetEmployees event,
      Emitter<EmployeesState> emit,
      ) async {
    emit(GettingEmployeesState());

    final box = Hive.box<EmployeeDetailsViewModel>(HiveTypes.employeeBox);
    List<EmployeeDetailsViewModel> mergedData = [];

    bool isConnected = true;

    // Only check for internet connectivity on non-web platforms
    if (!kIsWeb) {
      if (Instance.internetBloc.state is InternetInitial) {
        await Instance.internetBloc.stream.firstWhere(
              (state) =>
          state is InternetAvailable ||
              state is InternetConnected ||
              state is InternetDisconnected,
        );
      }

      isConnected = Instance.internetBloc.state is InternetAvailable ||
          Instance.internetBloc.state is InternetConnected;
    }

    // Always hit the API, regardless of platform
    final response = await Instance.employeesRepo.getCurrentEmployeeList();
    final apiData = response?.fold<List<EmployeeDetailsViewModel>?>(
          (l) => null,
          (r) => r,
    );

    if (apiData == null || (!kIsWeb && !isConnected)) {
      mergedData = box.values.toList();
      emit(ErrorGettingEmployeesState(
        errorMessage: "Error getting employees from server. Showing local data.",
      ));
    } else {
      await box.clear();

      final localData = box.values.toList();

      final Map<String, EmployeeDetailsViewModel> mergedMap = {
        for (var e in localData) e.id: e,
        for (var e in apiData) e.id: e,
      };

      mergedData = mergedMap.values.toList();

      for (final employee in mergedData) {
        box.put(employee.id, employee);
      }
    }

    final currentEmployees =
    mergedData.where((e) => e.endDate.isEmpty).toList();
    final previousEmployees =
    mergedData.where((e) => e.endDate.isNotEmpty).toList();

    Instance.employeesRepo = Instance.employeesRepo.copyWith(
      currentEmployeeList: currentEmployees,
      previousEmployeeList: previousEmployees,
    );

    emit(GotEmployeesState(
      currentEmployees: currentEmployees,
      previousEmployees: previousEmployees,
    ));
  }







  FutureOr<void> _addEmployee(
    AddEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(AddingEmployeeState());

    final currentModel =
        Instance.employeesRepo.selectedEmployeeDetailsViewModel;
    if (currentModel == null) return;

    final employee = EmployeeRequestModel(employeeDetails: currentModel);
    final response = await Instance.employeesRepo.addEmployee(employee);

    final data = response.fold<bool>(
      (l) {
        emit(ErrorAddingEmployeeState(errorMessage: l.toString()));
        return false;
      },
      (r) => r,
    );

    if (!data) {
      emit(ErrorAddingEmployeeState(errorMessage: "Error adding employee"));
      return;
    }

    final existingCurrentList = [
      ...?Instance.employeesRepo.currentEmployeeList
    ];
    final existingPreviousList = [
      ...?Instance.employeesRepo.previousEmployeeList
    ];

    List<EmployeeDetailsViewModel> updatedCurrentList = existingCurrentList;
    List<EmployeeDetailsViewModel> updatedPreviousList = existingPreviousList;

    if (currentModel.endDate.isEmpty) {
      // ✅ Check if employee already exists in current list
      final index =
          existingCurrentList.indexWhere((e) => e.id == currentModel.id);
      if (index != -1) {
        updatedCurrentList[index] = currentModel;
      } else {
        updatedCurrentList = [currentModel, ...existingCurrentList];
      }
      // Make sure it's not in the previous list
      updatedPreviousList =
          existingPreviousList.where((e) => e.id != currentModel.id).toList();
    } else {
      // ✅ Check if employee already exists in previous list
      final index =
          existingPreviousList.indexWhere((e) => e.id == currentModel.id);
      if (index != -1) {
        updatedPreviousList[index] = currentModel;
      } else {
        updatedPreviousList = [currentModel, ...existingPreviousList];
      }
      // Make sure it's not in the current list
      updatedCurrentList =
          existingCurrentList.where((e) => e.id != currentModel.id).toList();
    }

    Instance.employeesRepo = Instance.employeesRepo.copyWith(
      currentEmployeeList: updatedCurrentList,
      previousEmployeeList: updatedPreviousList,
    );

    // Save to local DB (update if already exists)
    final box = Hive.box<EmployeeDetailsViewModel>(HiveTypes.employeeBox);
    await box.put(currentModel.id, currentModel);

    // Clear temp form and selected model
    Instance.employeesRepo = Instance.employeesRepo.copyWith(
      selectedEmployeeDetailsViewModel: null,
      addUpdateEmployeeDetailsForm: null,
    );

    emit(AddedEmployeeState());
  }

  FutureOr<void> _updateEmployee(
    UpdateEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(UpdatingEmployeeState());

    final currentModel =
        Instance.employeesRepo.selectedEmployeeDetailsViewModel;
    if (currentModel == null) return;

    final employee = EmployeeRequestModel(employeeDetails: currentModel);
    final response = await Instance.employeesRepo.updateEmployee(employee);

    final data = response.fold<EmployeeDetailsViewModel?>(
      (l) {
        emit(ErrorUpdatingEmployeeState(errorMessage: l.toString()));
        return null;
      },
      (r) => r,
    );

    if (data == null) {
      emit(ErrorUpdatingEmployeeState(errorMessage: "Error updating employee"));
      return;
    }

    final existingCurrentList = [
      ...?Instance.employeesRepo.currentEmployeeList,
    ];
    final existingPreviousList = [
      ...?Instance.employeesRepo.previousEmployeeList,
    ];

    // Remove from current if present
    existingCurrentList.removeWhere((e) => e.id == data.id);

    // Remove from previous if present
    existingPreviousList.removeWhere((e) => e.id == data.id);

    // Reassign to the correct list based on endDate
    if (data.endDate.isEmpty) {
      existingCurrentList.insert(0, data);
    } else {
      existingPreviousList.insert(0, data);
    }

    // Update the Hive box
    final box = Hive.box<EmployeeDetailsViewModel>(HiveTypes.employeeBox);
    if (box.containsKey(data.id)) {
      await box.delete(data.id);
    }
    await box.put(data.id, data);

    // Update repository
    Instance.employeesRepo = Instance.employeesRepo.copyWith(
      currentEmployeeList: existingCurrentList,
      previousEmployeeList: existingPreviousList,
      selectedEmployeeDetailsViewModel: null,
      addUpdateEmployeeDetailsForm: null,
    );

    emit(UpdatedEmployeeState());
  }

  FutureOr<void> _deleteEmployee(
      DeleteEmployee event, Emitter<EmployeesState> emit) async {
    emit(DeletingEmployeeState());

    final response = await Instance.employeesRepo.deleteEmployee(event.id);
    final data = response.fold<bool>((l) {
      emit(ErrorDeletingEmployeeState(errorMessage: l.toString()));
      return false;
    }, (r) => r);
    if (data == false) {
      emit(ErrorDeletingEmployeeState(errorMessage: "Error deleting employee"));
      return;
    }

    final existingCurrentList = [
      ...?Instance.employeesRepo.currentEmployeeList
    ];
    final existingPreviousList = [
      ...?Instance.employeesRepo.previousEmployeeList
    ];

    final combinedList = [...existingCurrentList, ...existingPreviousList];
    final deletedModel = combinedList.firstWhere((e) => e.id == event.id);
    Instance.employeesRepo = Instance.employeesRepo.copyWith(
      deletedEmployeeDetailsViewModel: deletedModel,
    );
    final model = Instance.employeesRepo.deletedEmployeeDetailsViewModel;

    final currentIndex =
        existingCurrentList.indexWhere((e) => e.id == event.id);
    if (currentIndex != -1) {
      existingCurrentList.removeAt(currentIndex);
    }
    final previousIndex =
        existingPreviousList.indexWhere((e) => e.id == event.id);
    if (previousIndex != -1) {
      existingPreviousList.removeAt(previousIndex);
    }
    Instance.employeesRepo = Instance.employeesRepo.copyWith(
        currentEmployeeList: existingCurrentList,
        previousEmployeeList: existingPreviousList);
    final box = Hive.box<EmployeeDetailsViewModel>(HiveTypes.employeeBox);
    box.delete(event.id);
    if (model != null) {
      emit(DeletedEmployeeState(deletedEmployee: model));
    } else {
      emit(ErrorDeletingEmployeeState(errorMessage: "Error deleting employee"));
    }
  }

  FutureOr<void> _navigateTo(
      Navigate event, Emitter<EmployeesState> emit) async {
    emit(Navigating());
    final id = event.id;
    if (id != null) {
      final existingList = [
        ...?Instance.employeesRepo.currentEmployeeList,
        ...?Instance.employeesRepo.previousEmployeeList
      ];
      final employee = existingList.firstWhere((element) => element.id == id);
      Instance.employeesRepo = Instance.employeesRepo.copyWith(
          selectedEmployeeDetailsViewModel: employee,
          addUpdateEmployeeDetailsForm: AddUpdateEmployeeDetailsForm(
              name: NameInputField.pure(
                  NameInputFieldModelValue(value: employee.name))));
      emit(Navigated(employee));
      add(MarkFormCompleted());
    } else {
      Instance.employeesRepo = Instance.employeesRepo.copyWith(
          selectedEmployeeDetailsViewModel: null,
          addUpdateEmployeeDetailsForm: null);
      emit(Navigated(null));
      add(MarkFormCompleted());
    }
  }
}
