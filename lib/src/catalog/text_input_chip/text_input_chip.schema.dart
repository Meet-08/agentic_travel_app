import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/text_input_chip/text_input_chip_widget.dart';

final _schema = S.object(
  description:
      'An input chip used to ask the user to enter free text, e.g. to '
      'select a destination. This should only be used inside an InputGroup.',
  properties: {
    'label': S.string(description: 'The label for the text input chip.'),
    'value': A2uiSchemas.stringReference(
      description: 'The initial value for the text input.',
    ),
    'obscured': S.boolean(
      description: 'Whether the text should be obscured (e.g., for passwords).',
    ),
  },
  required: ["label"],
);

final textInputChip = CatalogItem(
  name: "TextInputChip",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "TextInputChip": {
              "value": {
                "literalString": "John Doe"
              },
              "label": "Enter your name"
            }
          }
        }
      ]
    ''',
    () => '''
      [
        {
          "id": "root",
          "component": {
            "TextInputChip": {
              "label": "Enter your password",
              "obscured": true
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final textInputChipData = TextInputChipData.fromMap(
      itemContext.data as Map<String, Object?>,
    );

    final JsonMap? valueRef = textInputChipData.value;
    final path = valueRef?["path"] as String?;
    final notifier = itemContext.dataContext.subscribeToString(valueRef);

    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, _) => TextInputChipWidget(
        label: textInputChipData.label,
        value: value,
        obscured: textInputChipData.obscured,
        onChanged: (newValue) {
          if (path != null) {
            itemContext.dataContext.update(DataPath(path), newValue);
          }
        },
      ),
    );
  },
);
