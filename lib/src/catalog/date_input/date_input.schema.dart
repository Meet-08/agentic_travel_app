import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/date_input/date_input_widget.dart';

final _schema = S.object(
  properties: {
    'value': A2uiSchemas.stringReference(
      description: 'The initial date of the date picker in yyyy-mm-dd format.',
    ),
    'label': S.string(description: 'Label for the date picker.'),
  },
);

final dateInputChip = CatalogItem(
  name: "DateInputChip",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "DateInputChip": {
              "value": {
                "literalString": "1871-07-22"
              },
              "label": "Your birth date"
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final datePickerData = DatePickerData.fromMap(itemContext.data as JsonMap);
    final notifier = itemContext.dataContext.subscribeToString(
      datePickerData.value,
    );
    final path = datePickerData.value?['path'] as String?;
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) => DateInputWidget(
        initialValue: value,
        label: datePickerData.label,
        onChanged: (newDate) {
          if (path != null) {
            itemContext.dataContext.update(DataPath(path), newDate);
          }
        },
      ),
    );
  },
);
