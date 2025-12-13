import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class OptionFilterChipWidget extends StatefulWidget {
  final String chipLabel;
  final List<String> options;
  final IconData? icon;
  final String? value;
  final void Function(String?) onChanged;

  const OptionFilterChipWidget({
    super.key,
    required this.chipLabel,
    required this.options,
    this.icon,
    this.value,
    required this.onChanged,
  });

  @override
  State<OptionFilterChipWidget> createState() => _OptionFilterChipWidgetState();
}

class _OptionFilterChipWidgetState extends State<OptionFilterChipWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant OptionFilterChipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _selectedValue = widget.value;
  }

  String get _currentChipLabel => _selectedValue ?? widget.chipLabel;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: widget.icon != null ? Icon(widget.icon) : null,
      label: Text(_currentChipLabel),
      selected: false,
      shape: RoundedRectangleBorder(borderRadius: .circular(20.0)),
      onSelected: (bool selected) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            String? tempValue = _selectedValue;
            return StatefulBuilder(
              builder: (context, setModalState) => RadioGroup<String?>(
                groupValue: tempValue,
                onChanged: (newValue) {
                  setModalState(() => tempValue = newValue);
                  widget.onChanged(newValue);
                  if (newValue != null) {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisSize: .min,
                  children: widget.options
                      .map(
                        (option) =>
                            RadioListTile(title: Text(option), value: option),
                      )
                      .toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

extension type OptionsFilterChipInputData.fromMap(Map<String, Object?> _json) {
  factory OptionsFilterChipInputData({
    required String chipLabel,
    required List<String> options,
    String? iconName,
    JsonMap? value,
  }) => OptionsFilterChipInputData.fromMap({
    'chipLabel': chipLabel,
    'options': options,
    if (iconName != null) 'iconName': iconName,
    if (value != null) 'value': value,
  });

  String get chipLabel => _json['chipLabel'] as String;
  List<String> get options => (_json['options'] as List).cast<String>();
  String? get iconName => _json['iconName'] as String?;
  JsonMap? get value => _json['value'] as JsonMap?;
}
