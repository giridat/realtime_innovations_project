import 'package:flutter/material.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile({
    super.key,
    required this.onEdit,
    required this.onDismissed,
    required this.employeeDetailsViewModel,
  });

  final EmployeeDetailsViewModel employeeDetailsViewModel;
  final Function() onEdit;
  final Function(DismissDirection) onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(employeeDetailsViewModel.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employeeDetailsViewModel.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16,),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employeeDetailsViewModel.role,
                    style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employeeDetailsViewModel.endDate.isNotEmpty
                        ? "${employeeDetailsViewModel.startDate} - ${employeeDetailsViewModel.endDate}"
                        : "From ${employeeDetailsViewModel.startDate}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
