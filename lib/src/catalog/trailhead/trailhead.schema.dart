import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/trailhead/trailhead_widget.dart';

final _schema = S.object(
  properties: {
    'topics': S.list(
      description: 'A list of topics to display as chips.',
      items: A2uiSchemas.stringReference(description: 'A topic to explore.'),
    ),
    'action': A2uiSchemas.action(
      description:
          'The action to perform when a topic is selected. The selected topic '
          'will be added to the context with the key "topic".',
    ),
  },
  required: ["topics", "action"],
);

final trailHead = CatalogItem(
  name: "TrailHead",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "Trailhead": {
              "topics": [
                {
                  "literalString": "Topic 1"
                },
                {
                  "literalString": "Topic 2"
                },
                {
                  "literalString": "Topic 3"
                }
              ],
              "action": {
                "name": "select_topic"
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final trailheadData = TrailheadData.fromMap(
      itemContext.data as Map<String, Object?>,
    );

    return TrailheadWidget(
      topics: trailheadData.topics,
      action: trailheadData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);
