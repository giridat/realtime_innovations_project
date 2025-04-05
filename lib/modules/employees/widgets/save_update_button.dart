import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/modules/employees/bloc/employees_bloc.dart';

class SaveUpdateButton extends StatelessWidget {
  const SaveUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      buildWhen: (previous, current) {
        return switch (current) {
          ErrorValidatingFormState() => true,
          FormValidatedSuccessfully() => true,
          _ => false
        };
      },
      builder: (context, state) {
        final isEnabled = switch (state) {
          ErrorValidatingFormState() => false,
          FormValidatedSuccessfully() => true,
          _ => Instance.employeesRepo.isFormComplete ?? false
        };
        final isLoading = switch (state) {
          AddingEmployeeState() => true,
          UpdatingEmployeeState() => true,
          _ => false
        };
        return ElevatedButton(
          onPressed: isEnabled && !isLoading
              ? () => context.read<EmployeesBloc>().add(AddEmployee())
              : null,
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          child: isLoading ? const CircularProgressIndicator() : const Text('Save'),
        );
      },
    );
  }
}
