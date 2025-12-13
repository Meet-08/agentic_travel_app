import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/checkbox_filter_chips/checkbox_filter_chip_widget.dart';
import 'package:travel_app/src/common.dart';

final _schema = S.object(
  description:
      'A chip used to choose from a set of options where *more than one* '
      'option can be chosen. This *must* be placed inside an InputGroup.',
  properties: {
    'chipLabel': S.string(
      description:
          'The title of the filter chip e.g. "amenities" or "dietary '
          'restrictions" etc',
    ),
    'options': S.list(
      description: '''The list of options that the user can choose from.''',
      items: S.string(),
    ),
    'iconName': S.string(
      description: 'An icon to display on the left of the chip.',
      enumValues: TravelIcon.values.map((e) => e.name).toList(),
    ),
    'selectedOption': A2uiSchemas.stringArrayReference(
      description:
          'The names of the options that should be selected '
          'initially. These options must exist in the "options" list.',
    ),
  },
  required: ['chipLabel', 'options', 'selectedOptions'],
);

final checkboxFilterChipsInput = CatalogItem(
  name: "checkboxFilterChipsInput",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "CheckboxFilterChipsInput": {
              "chipLabel": "Amenities",
              "options": [
                "Wifi",
                "Gym",
                "Pool",
                "Parking"
              ],
              "selectedOptions": {
                "literalArray": [
                  "Wifi",
                  "Gym"
                ]
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final checkboxFilterChipsData = CheckboxFilterChipsInputData.fromMap(
      itemContext.data as Map<String, dynamic>,
    );

    final JsonMap selectedOptionsRef = checkboxFilterChipsData.selectedOptions;
    final notifier = itemContext.dataContext.subscribeToObjectArray(
      selectedOptionsRef,
    );

    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, currentSelectedValues, child) {
        final Set<String> selectedOptionsSet = (currentSelectedValues ?? [])
            .cast<String>()
            .toSet();

        return CheckboxFilterChipWidget(
          chipLabel: checkboxFilterChipsData.chipLabel,
          options: checkboxFilterChipsData.options,
          selectedOptions: selectedOptionsSet,
          icon: checkboxFilterChipsData.iconName != null
              ? iconFor(
                  TravelIcon.values.byName(checkboxFilterChipsData.iconName!),
                )
              : null,
          onChanged: (newSelectedOptions) {
            final path = selectedOptionsRef['path'] as String?;
            if (path != null) {
              itemContext.dataContext.update(
                DataPath(path),
                newSelectedOptions.toList(),
              );
            }
          },
        );
      },
    );
  },
);
