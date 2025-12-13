import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/tabbed_sections/tabbed_section_data.dart';
import 'package:travel_app/src/catalog/tabbed_sections/tabbed_sections_widget.dart';

final _schema = S.object(
  properties: {
    'sections': S.list(
      description: 'A list of sections to display as tabs.',
      items: S.object(
        properties: {
          'title': A2uiSchemas.stringReference(
            description: 'The title of the tab.',
          ),
          'child': A2uiSchemas.componentReference(
            description: 'The ID of the child widget for the tab content.',
          ),
        },
        required: ["title"],
      ),
    ),
  },
  required: ["sections"],
);

final tabbedSections = CatalogItem(
  name: "TabbedSections",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "TabbedSections": {
              "sections": [
                {
                  "title": {
                    "literalString": "Tab 1"
                  },
                  "child": "tab1_content"
                },
                {
                  "title": {
                    "literalString": "Tab 2"
                  },
                  "child": "tab2_content"
                }
              ]
            }
          }
        },
        {
          "id": "tab1_content",
          "component": {
            "Text": {
              "text": {
                "literalString": "This is the content of Tab 1."
              }
            }
          }
        },
        {
          "id": "tab2_content",
          "component": {
            "Text": {
              "text": {
                "literalString": "This is the content of Tab 2."
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final tabbedSectionsData = TabbedSectionsData.fromMap(
      itemContext.data as Map<String, Object?>,
    );

    final sections = tabbedSectionsData.sections.map((section) {
      final titleNotifier = itemContext.dataContext.subscribeToString(
        section.title,
      );

      return TabSectionData(
        titleNotifier: titleNotifier,
        childId: section.childId,
      );
    }).toList();

    return TabbedSectionsWidget(
      sections: sections,
      buildChild: itemContext.buildChild,
    );
  },
);
