import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:intl/intl.dart';

class DateInputWidget extends StatefulWidget {
  final String? initialValue;
  final String? label;
  final void Function(String) onChanged;

  const DateInputWidget({
    super.key,
    this.initialValue,
    this.label,
    required this.onChanged,
  });

  @override
  State<DateInputWidget> createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedDate = DateTime.tryParse(widget.initialValue!);
    }
  }

  @override
  void didUpdateWidget(covariant DateInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue != null) {
        _selectedDate = DateTime.tryParse(widget.initialValue!);
      } else {
        _selectedDate = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String text = _selectedDate == null
        ? widget.label ?? 'Date'
        : '${widget.label}: ${DateFormat.yMMMd().format(_selectedDate!)}';
    return FilterChip(
      label: Text(text),
      selected: false,
      shape: RoundedRectangleBorder(borderRadius: .circular(20.0)),
      onSelected: (bool selected) {
        showModalBottomSheet(
          context: context,
          builder: (context) => SizedBox(
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: CalendarDatePicker(
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1700),
                    lastDate: DateTime(2101),
                    onDateChanged: (newDate) {
                      setState(() => _selectedDate = newDate);
                      final String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(newDate);
                      widget.onChanged(formattedDate);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension type DatePickerData.fromMap(JsonMap _json) {
  factory DatePickerData({JsonMap? value, String? label}) =>
      DatePickerData.fromMap({'value': value, 'label': label});

  JsonMap? get value => _json['value'] as JsonMap?;
  String? get label => _json['label'] as String?;
}
