import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/option_filter_chip/option_filter_chip_widget.dart';
import 'package:travel_app/src/common.dart';

final _schema = S.object(
  description:
      'A chip used to choose from a set of mutually exclusive '
      'options. This *must* be placed inside an InputGroup.',
  properties: {
    'chipLabel': S.string(
      description:
          'The title of the filter chip e.g. "budget" or "activity type" '
          'etc',
    ),
    'options': S.list(
      description:
          '''The list of options that the user can choose from. There should be at least three of these.''',
      items: S.string(),
    ),
    'iconName': S.string(
      description: 'An icon to display on the left of the chip.',
      enumValues: TravelIcon.values.map((e) => e.name).toList(),
    ),
    'value': A2uiSchemas.stringReference(
      description:
          'The name of the option that should be selected initially. This '
          'option must exist in the "options" list.',
    ),
  },
  required: ['chipLabel', 'options'],
);

final optionFilterChipInput = CatalogItem(
  name: "OptionsFilterChipInput",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "OptionsFilterChipInput": {
              "chipLabel": "Budget",
              "options": [
                "\$",
                "\$\$",
                "\$\$\$"
              ],
              "value": {
                "literalString": "\$\$"
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final optionsFilterChipData = OptionsFilterChipInputData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    IconData? icon;
    if (optionsFilterChipData.iconName != null) {
      try {
        icon = iconFor(
          TravelIcon.values.byName(optionsFilterChipData.iconName!),
        );
      } catch (e) {
        icon = null;
      }
    }

    final JsonMap? valueRef = optionsFilterChipData.value;
    final path = valueRef?['path'] as String?;
    final ValueNotifier<String?> notifier = itemContext.dataContext
        .subscribeToString(valueRef);

    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) => OptionFilterChipWidget(
        chipLabel: optionsFilterChipData.chipLabel,
        icon: icon,
        options: optionsFilterChipData.options,
        onChanged: (newValue) {
          if (path != null && newValue != null) {
            itemContext.dataContext.update(DataPath(path), newValue);
          }
        },
      ),
    );
  },
);
