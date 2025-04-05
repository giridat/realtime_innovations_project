import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;

  final bool isEndDate;

  const CustomDatePickerDialog(
      {super.key, required this.initialDate, required this.isEndDate});

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  void _setDate(DateTime? date) {
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    } else {
      setState(() {
        selectedDate = null;
      });
    }
  }

  DateTime getNextMonday() {
    DateTime now = DateTime.now();
    int daysToAdd = (8 - now.weekday) % 7;
    return now.add(Duration(days: daysToAdd));
  }

  DateTime getNextTuesday() {
    DateTime now = DateTime.now();
    int daysToAdd = (9 - now.weekday) % 7;
    return now.add(Duration(days: daysToAdd));
  }

  DateTime getNextWeek() {
    return DateTime.now().add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: kIsWeb?4.5:3.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (widget.isEndDate == true) _noDateButton(),
                        _quickSelectButton('Today', DateTime.now()),
                        if (widget.isEndDate == false)
                          _quickSelectButton('Next Monday', getNextMonday()),
                        if (widget.isEndDate == false)
                          _quickSelectButton('Next Tuesday', getNextTuesday()),
                        if (widget.isEndDate == false)
                          _quickSelectButton('After 1 week', getNextWeek()),
                      ],
                    ),
                  ),
                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      modePickersGap: 0,
                      nextMonthIcon: Icon(Icons.arrow_right_sharp),
                      lastMonthIcon: Icon(Icons.arrow_left_sharp),
                      currentDate: selectedDate,
                      centerAlignModePicker: true,
                      weekdayLabelTextStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor: Colors.blue,
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                    ),
                    value: [selectedDate],
                    onValueChanged: (dates) {
                      if (dates.isNotEmpty) {
                        _setDate(dates.first);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Color.fromRGBO(242, 242, 242, 1)),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? DateFormat('d MMM, yyyy').format(selectedDate!)
                      : 'No date',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
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
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedDate),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  // Widget? modePickerBuilder({
  //   bool? isMonthPicker, // This should be used properly
  //   required DateTime monthDate,
  //   required CalendarDatePicker2Mode viewMode,
  // }) {
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       setState(() {
  //         isMonthPicker =false;
  //       });
  //       return Column(
  //         children: [
  //
  //           if (isMonthPicker == true)
  //             // Show year selection UI
  //             Row(
  //               children: [
  //                 IconButton(
  //                   icon: Icon(Icons.chevron_left, color: Colors.grey.shade600),
  //                   onPressed: () {
  //                     setState(() {
  //                       isMonthPicker =true;
  //                     });
  //                     setState(() {
  //                       monthDate =
  //                           DateTime(monthDate.year, monthDate.month - 1, 1);
  //                     });
  //                   },
  //                 ),
  //                 Text(
  //                   DateFormat('MMMM').format(monthDate),
  //                   style: const TextStyle(
  //                       fontSize: 16, fontWeight: FontWeight.bold),
  //                 ),
  //                 IconButton(
  //                   icon:
  //                       Icon(Icons.chevron_right, color: Colors.grey.shade600),
  //                   onPressed: () {
  //                     setState(() {
  //                       monthDate =
  //                           DateTime(monthDate.year, monthDate.month + 1, 1);
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //
  //           if(isMonthPicker==false)
  //           Row(
  //             // Ensures vertical alignment
  //             children: [
  //               IconButton(
  //                 icon: Icon(Icons.chevron_left, color: Colors.grey.shade600),
  //                 onPressed: () {
  //                   setState(() {
  //                     monthDate =
  //                         DateTime(monthDate.year - 1, monthDate.month, 1);
  //                   });
  //                 },
  //               ),
  //
  //               /// Wrap the text inside `Expanded` to prevent overflow
  //               Text(
  //                 DateFormat('yyyy').format(monthDate),
  //                 style: const TextStyle(
  //                     fontSize: 16, fontWeight: FontWeight.bold),
  //                 textAlign: TextAlign.center,
  //               ),
  //
  //               IconButton(
  //                 icon: Icon(Icons.chevron_right, color: Colors.grey.shade600),
  //                 onPressed: () {
  //                   setState(() {
  //                     monthDate =
  //                         DateTime(monthDate.year + 1, monthDate.month, 1);
  //                   });
  //                 },
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
  Widget _noDateButton() {
    final isSelected = selectedDate == null;

    return OutlinedButton(
      onPressed: () => _setDate(null),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.red : const Color.fromRGBO(234, 245, 255, 1),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        "No Date",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color:
              isSelected ? Colors.white : const Color.fromRGBO(29, 161, 242, 1),
        ),
      ),
    );
  }

  Widget _quickSelectButton(String label, DateTime date) {
    final isSelected = DateUtils.isSameDay(date, selectedDate);

    return OutlinedButton(
      onPressed: () => _setDate(date),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.blue : const Color.fromRGBO(234, 245, 255, 1),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color:
              isSelected ? Colors.white : const Color.fromRGBO(29, 161, 242, 1),
        ),
      ),
    );
  }
}
