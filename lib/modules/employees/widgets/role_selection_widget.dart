import 'package:flutter/material.dart';

class RoleSelectionField extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String> onRoleSelected;

  const RoleSelectionField({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showRoleSelectionSheet(context, onRoleSelected),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.work_outline,
            color: Colors.blue,
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.blue,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
          ),
          border:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Color.fromRGBO(229, 229, 229, 1), width: 1),
          ),
        ),
        child: Text(
          selectedRole ?? "Select a role",
          style: TextStyle(
              color: selectedRole == null ? Colors.grey : Colors.black),
        ),
      ),
    );
  }

  void showRoleSelectionSheet(
      BuildContext context, Function(String) onRoleSelected) {
    List<String> roles = [
      "Product Designer",
      "Flutter Developer",
      "QA Tester",
      "Product Owner"
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            itemCount: roles.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(roles[index],textAlign: TextAlign.center,),
                    onTap: () {
                      onRoleSelected(roles[index]);
                      Navigator.pop(context);
                    },
                  ),
                  if (index != roles.length - 1) const Divider(
                    color:  Color.fromRGBO(229, 229, 229, 1),
                  ),
                  // Divider between items
                ],
              );
            },
          ),
        );
      },
    );
  }
}
