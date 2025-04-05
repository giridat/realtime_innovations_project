import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/common/widgets/input_field.dart';
import 'package:realtime_innovations_project/generated/assets.dart';
import 'package:realtime_innovations_project/modules/employees/bloc/employees_bloc.dart';
import 'package:realtime_innovations_project/modules/employees/models/add_update_employee_details_form.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';
import 'package:realtime_innovations_project/modules/employees/models/name_input_field_model_value.dart';
import 'package:realtime_innovations_project/modules/employees/widgets/role_selection_widget.dart';
import 'package:realtime_innovations_project/modules/employees/widgets/save_update_button.dart';

import 'calendar_picker_widget.dart';
import 'date_picker.dart';

class AddEmployeeDetailsFormBody extends StatelessWidget {
  const AddEmployeeDetailsFormBody(
      {super.key,
      this.employee,
      required this.nameFocusNode,
      required this.nameController});

  final EmployeeDetailsViewModel? employee;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;

  DateTime? _parseFormattedDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat("d MMM, yyyy").parse(dateString);
    } catch (e) {
      return null;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this employee?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<EmployeesBloc>()
                    .add(DeleteEmployee(id: employeeId));
                Navigator.of(dialogContext).pop(); // Close dialog after action
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
        buildWhen: (current, previous) {
      return switch (current) {
        CreateNameInputFieldState() => true,
        ValidateNameInputFieldState() => true,
        SelectingEndDate() => true,
        SelectingStartDate() => true,
        StartDateSelected() => true,
        EndDateSelected() => true,
        SettingRole() => true,
        RoleSetSuccessfully() => true,
        _ => false,
      };
    }, builder: (context, state) {
      final role = switch (state) {
        RoleSetSuccessfully() => state.role,
        _ =>
          Instance.employeesRepo.selectedEmployeeDetailsViewModel?.role ?? '',
      };

      final startDate = switch (state) {
        StartDateSelected() => state.startDate,
        _ => _parseFormattedDate(
            Instance.employeesRepo.selectedEmployeeDetailsViewModel?.startDate),
      };
      final endDate = switch (state) {
        EndDateSelected() => state.endDate,
        _ => _parseFormattedDate(
            Instance.employeesRepo.selectedEmployeeDetailsViewModel?.endDate),
      };

      final form = switch (state) {
        CreateNameInputFieldState() => state.form,
        ValidateNameInputFieldState() => state.form,
        _ => Instance.employeesRepo.addUpdateEmployeeDetailsForm ??
            AddUpdateEmployeeDetailsForm.pure(),
      };

      return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          persistentFooterButtons: [
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: const Color.fromRGBO(237, 248, 255, 1),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(29, 161, 242, 1),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SaveUpdateButton()
              ],
            ),
          ],
          appBar: AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            title: Text(
              employee != null
                  ? 'Edit Employee Details'
                  : 'Add Employee Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: employee != null
                ? [
                    IconButton(
                        onPressed: () {
                          final employee = this.employee;

                          if (employee != null) {
                            _showDeleteConfirmationDialog(context, employee.id);
                          }
                        },
                        icon: SvgPicture.asset(
                            Assets.assetsDeleteFILL0Wght300GRAD0Opsz24))
                  ]
                : null,
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      text: 'Name ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                InputField(
                    inputModel: form.name,
                    controller: nameController,
                    focusNode: nameFocusNode,
                    enabled: true,
                    onChanged: (value) {
                      final updatedValue = form.copyWith(
                          name: NameInputField.dirty(form.name.value.copyWith(
                        value: value,
                        showServerErrorFlag: false,
                        serverErrorMessage: null,
                      )));
                      context
                          .read<EmployeesBloc>()
                          .add(OnNameFieldChanged(name: updatedValue));
                    },
                    inputFormatters: {},
                    autofillHints: [
                      AutofillHints.name,
                      AutofillHints.namePrefix,
                      AutofillHints.nameSuffix,
                      AutofillHints.username,
                      AutofillHints.nickname
                    ]),
                SizedBox(
                  height: 23,
                ),
                RoleSelectionField(
                  selectedRole: role.isEmpty ? null : role,
                  onRoleSelected: (value) {
                    context
                        .read<EmployeesBloc>()
                        .add(SetRoleEvent(role: value));
                  },
                ),
                SizedBox(
                  height: 23,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      text: 'Start Date ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDialog<DateTime>(
                            context: context,
                            builder: (context) => CustomDatePickerDialog(
                              initialDate: startDate ?? DateTime.now(),
                              isEndDate: false,
                            ),
                          );
                          if (pickedDate != null) {
                            context.read<EmployeesBloc>().add(
                                OnStartDateSelected(startDate: pickedDate));
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(229, 229, 229, 1)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(229, 229, 229, 1),
                                  width: 1),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.blue,
                            ), //  prefixIcon
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                          ),
                          child: Text(
                            startDate != null
                                ? DateFormat('d MMM, yyyy').format(startDate)
                                : "Today", // Default text when no date is selected
                            style: TextStyle(
                                fontSize: 16,
                                color: startDate != null
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.arrow_forward, color: Colors.blue),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDialog<DateTime>(
                            context: context,
                            builder: (context) => CustomDatePickerDialog(
                              initialDate: endDate ?? DateTime.now(),
                              isEndDate: true,
                            ),
                          );
                          context
                              .read<EmployeesBloc>()
                              .add(OnEndDateSelected(endDate: pickedDate));
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(229, 229, 229, 1)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(229, 229, 229, 1),
                                  width: 1),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.blue,
                            ), // Moved to prefixIcon
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                          ),
                          child: Text(
                            endDate != null
                                ? DateFormat('d MMM, yyyy').format(endDate)
                                : "No Date", // Default text when no date is selected
                            style: TextStyle(
                                fontSize: 16,
                                color: endDate != null
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ])));
    });
  }
}
