import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class CheckboxFilterChipWidget extends StatelessWidget {
  final String chipLabel;
  final List<String> options;
  final IconData? icon;
  final Set<String> selectedOptions;
  final void Function(Set<String>) onChanged;

  const CheckboxFilterChipWidget({
    super.key,
    required this.chipLabel,
    required this.options,
    this.icon,
    required this.selectedOptions,
    required this.onChanged,
  });

  String get _displayLabel {
    if (selectedOptions.isEmpty) {
      return chipLabel;
    }
    return selectedOptions.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: icon != null ? Icon(icon) : null,
      label: Text(_displayLabel),
      onSelected: (bool selected) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            Set<String> tempSelectedOptions = Set.from(selectedOptions);
            return StatefulBuilder(
              builder: (context, setModalState) => Column(
                mainAxisSize: .min,
                children: options
                    .map(
                      (option) => CheckboxListTile(
                        title: Text(option),
                        value: tempSelectedOptions.contains(option),
                        onChanged: (bool? newValue) {
                          setModalState(() {
                            if (newValue == true) {
                              tempSelectedOptions.add(option);
                            } else {
                              tempSelectedOptions.remove(option);
                            }
                          });
                          onChanged(tempSelectedOptions);
                        },
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}

extension type CheckboxFilterChipsInputData.fromMap(
  Map<String, Object?> _json
) {
  factory CheckboxFilterChipsInputData({
    required String chipLabel,
    required List<String> options,
    String? iconName,
    required JsonMap selectedOptions,
  }) => CheckboxFilterChipsInputData.fromMap({
    'chipLabel': chipLabel,
    'options': options,
    if (iconName != null) 'iconName': iconName,
    'selectedOptions': selectedOptions,
  });

  String get chipLabel => _json['chipLabel'] as String;
  List<String> get options => (_json['options'] as List).cast<String>();
  String? get iconName => _json['iconName'] as String?;
  JsonMap get selectedOptions => _json['selectedOptions'] as JsonMap;
}
