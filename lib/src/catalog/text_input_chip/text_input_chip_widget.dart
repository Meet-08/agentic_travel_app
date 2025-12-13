import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class TextInputChipWidget extends StatefulWidget {
  final String label;
  final String? value;
  final bool obscured;
  final void Function(String) onChanged;

  const TextInputChipWidget({
    super.key,
    required this.label,
    this.value,
    required this.obscured,
    required this.onChanged,
  });

  @override
  State<TextInputChipWidget> createState() => _TextInputChipWidgetState();
}

class _TextInputChipWidgetState extends State<TextInputChipWidget> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value ?? "");
  }

  @override
  void didUpdateWidget(covariant TextInputChipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _textController.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        widget.obscured && (widget.value?.isNotEmpty ?? false)
            ? '********'
            : widget.value ?? widget.label,
      ),
      selected: false,
      shape: RoundedRectangleBorder(borderRadius: .circular(20.0)),
      onSelected: (bool selected) => showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                obscureText: widget.obscured,
                decoration: InputDecoration(labelText: widget.label),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final String newValue = _textController.text;
                  if (newValue.isNotEmpty) {
                    widget.onChanged(newValue);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension type TextInputChipData.fromMap(Map<String, Object?> _json) {
  factory TextInputChipData({
    required String label,
    JsonMap? value,
    bool? obscured,
  }) => TextInputChipData.fromMap({
    'label': label,
    if (value != null) 'value': value,
    'obscured': obscured ?? false,
  });

  String get label => _json['label'] as String;
  JsonMap? get value => _json['value'] as JsonMap?;
  bool get obscured => _json['obscured'] as bool? ?? false;
}
