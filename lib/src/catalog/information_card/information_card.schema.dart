import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/information_card/information_card_widget.dart';

final _schema = S.object(
  properties: {
    'title': A2uiSchemas.stringReference(description: 'The title of the card.'),
    'subtitle': A2uiSchemas.stringReference(
      description: 'The subtitle of the card.',
    ),
    'imageChildId': S.string(
      description:
          'The ID of the Image widget to display at the top of the '
          'card. The Image fit should typically be "cover". Be sure to create '
          'an Image widget with a matching ID.',
    ),
    'body': A2uiSchemas.stringReference(
      description: 'The body text of the card. This supports markdown.',
    ),
  },
  required: ["title", "body"],
);

final informationCard = CatalogItem(
  name: "InformationCard",
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "InformationCard": {
              "title": {
                "literalString": "Beautiful Scenery"
              },
              "subtitle": {
                "literalString": "A stunning view"
              },
              "body": {
                "literalString": "This is a beautiful place to visit in the summer."
              },
              "imageChildId": "image1"
            }
          }
        },
        {
          "id": "image1",
          "component": {
            "Image": {
              "url": {
                "literalString": "assets/travel_images/canyonlands_national_park_utah.jpg"
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final cardData = InformationCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );

    final Widget? imageChild = cardData.imageChildId != null
        ? itemContext.buildChild(cardData.imageChildId!)
        : null;

    final ValueNotifier<String?> titleNotifier = itemContext.dataContext
        .subscribeToString(cardData.title);
    final ValueNotifier<String?> subtitleNotifier = itemContext.dataContext
        .subscribeToString(cardData.subtitle);
    final ValueNotifier<String?> bodyNotifier = itemContext.dataContext
        .subscribeToString(cardData.body);

    return InformationCardWidget(
      imageChild: imageChild,
      titleNotifier: titleNotifier,
      subtitleNotifier: subtitleNotifier,
      bodyNotifier: bodyNotifier,
    );
  },
);
