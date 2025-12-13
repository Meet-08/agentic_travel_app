import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/input_group/input_group_widget.dart';

final _schema = S.object(
  properties: {
    'submitLabel': A2uiSchemas.stringReference(
      description: 'The label for the submit button.',
    ),
    'children': S.list(
      description:
          'A list of widget IDs for the input children, which must '
          'be input types such as OptionsFilterChipInput.',
      items: S.string(),
    ),
    'action': A2uiSchemas.action(
      description:
          'The action to perform when the submit button is pressed. '
          'The context for this action should include references to the values '
          'of all the input chips inside this group, so that the model can '
          'know what the user has selected.',
    ),
  },
  required: ['submitLabel', 'children', 'action'],
);

final inputGroup = CatalogItem(
  name: "InputGroup",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "InputGroup": {
              "submitLabel": {
                "literalString": "Submit"
              },
              "children": [
                "check_in",
                "check_out",
                "text_input1",
                "text_input2"
              ],
              "action": {
                "name": "submit_form"
              }
            }
          }
        },
        {
          "id": "check_in",
          "component": {
            "DateInputChip": {
              "value": {
                "literalString": "2026-07-22"
              },
              "label": "Check-in date"
            }
          }
        },
        {
          "id": "check_out",
          "component": {
            "DateInputChip": {
              "label": "Check-out date"
            }
          }
        },
        {
          "id": "text_input1",
          "component": {
            "TextInputChip": {
              "value": {
                "literalString": "John Doe"
              },
              "label": "Enter your name"
            }
          }
        },
        {
          "id": "text_input2",
          "component": {
            "TextInputChip": {
              "label": "Enter your friend's name"
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final inputGroupData = InputGroupData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    final notifier = itemContext.dataContext.subscribeToString(
      inputGroupData.submitLabel,
    );

    final List<String> children = inputGroupData.children;
    final JsonMap actionData = inputGroupData.action;
    final name = actionData['name'] as String;
    final List<Object?> contextDefinition =
        (actionData['context'] as List<Object?>?) ?? <Object?>[];

    return Card(
      color: Theme.of(itemContext.buildContext).colorScheme.primaryContainer,
      child: Padding(
        padding: const .all(8.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Wrap(
              runSpacing: 16.0,
              spacing: 8.0,
              children: children.map(itemContext.buildChild).toList(),
            ),
            const SizedBox(height: 16.0),
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, submitLabel, child) => ElevatedButton(
                onPressed: () {
                  final resolvedContext = resolveContext(
                    itemContext.dataContext,
                    contextDefinition,
                  );

                  itemContext.dispatchEvent(
                    UserActionEvent(
                      name: name,
                      sourceComponentId: itemContext.id,
                      context: resolvedContext,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(submitLabel ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
