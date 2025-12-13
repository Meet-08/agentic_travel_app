import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

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
