import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:realtime_innovations_project/generated/assets.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(

        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Color.fromRGBO(148, 156, 158, 1),
            fontWeight: FontWeight.w400,
            fontSize: 14


          ),
          prefixIcon: Icon(Icons.calendar_month,color: Colors.blue,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Color.fromRGBO(229, 229, 229, 1), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
          ),
        ),
        child: Text(
          style:  TextStyle(
              color: Color.fromRGBO(148, 156, 158, 1),
              fontWeight: FontWeight.w400,
              fontSize: 14


          ),
          selectedDate == null
              ? label
              : DateFormat("d MMM, yyyy").format(selectedDate!),
        ),
      ),
    );
  }
}
