import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary_data.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary_widget.dart';

enum ItineraryEntryType { accommodation, transport, activity }

enum ItineraryEntryStatus { noBookingRequired, choiceRequired, chosen }

final _schema = S.object(
  description: 'Widget to show an itinerary or a plan for travel.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'The title of the itinerary.',
    ),
    'subTitle': A2uiSchemas.stringReference(
      description: 'The subheading of the itinerary.',
    ),
    'imageChildId': A2uiSchemas.componentReference(
      description:
          'The ID of the Image widget to display. The Image fit '
          "should typically be 'cover'. Be sure to create an Image widget "
          'with a matching ID.',
    ),
    'days': S.list(
      description: 'A list of days in the itinerary.',
      items: S.object(
        properties: {
          'title': A2uiSchemas.stringReference(
            description: 'The title for the day, e.g., "Day 1".',
          ),
          'subtitle': A2uiSchemas.stringReference(
            description: 'The subtitle for the day, e.g., "Arrival in Tokyo".',
          ),
          'description': A2uiSchemas.stringReference(
            description:
                'A short description of the day\'s plan. '
                'This supports markdown.',
          ),
          'imageChildId': A2uiSchemas.componentReference(
            description:
                'The ID of the Image widget to display. The Image fit should '
                'typically be \'cover\'.',
          ),
          'entries': S.list(
            description:
                'A list of widget IDs for the ItineraryEntry '
                'children for this day.',
            items: S.object(
              properties: {
                'title': A2uiSchemas.stringReference(
                  description: 'The title of the itinerary entry.',
                ),
                'subtitle': A2uiSchemas.stringReference(
                  description: 'The subtitle of the itinerary entry.',
                ),
                'bodyText': A2uiSchemas.stringReference(
                  description:
                      'The body text for the entry. This supports markdown.',
                ),
                'address': A2uiSchemas.stringReference(
                  description: 'The address for the entry.',
                ),
                'time': A2uiSchemas.stringReference(
                  description: 'The time for the entry (formatted string).',
                ),
                'totalCost': A2uiSchemas.stringReference(
                  description: 'The total cost for the entry.',
                ),
                'type': S.string(
                  description: 'The type of the itinerary entry.',
                  enumValues: ItineraryEntryType.values
                      .map((e) => e.name)
                      .toList(),
                ),
                'status': S.string(
                  description:
                      'The booking status of the itinerary entry. '
                      'Use "noBookingRequired" for activities that do not '
                      'require a booking, like visiting a public park. '
                      'Use "choiceRequired" when the user needs to make a '
                      'decision, like selecting a specific hotel or flight. '
                      'Use "chosen" after the user has made a selection and '
                      'the booking is confirmed.',
                  enumValues: ItineraryEntryStatus.values
                      .map((e) => e.name)
                      .toList(),
                ),
                'choiceRequiredAction': A2uiSchemas.action(
                  description:
                      'The action to perform when the user needs to '
                      'make a choice. This is only used when the status is '
                      '"choiceRequired". The context for this action should '
                      'include the title of this itinerary entry.',
                ),
              },
              required: ['title', 'bodyText', 'time', 'type', 'status'],
            ),
          ),
        },
        required: [
          'title',
          'subtitle',
          'description',
          'imageChildId',
          'entries',
        ],
      ),
    ),
  },
  required: ['title', 'subheading', 'imageChildId', 'days'],
);

final itinerary = CatalogItem(
  name: 'Itinerary',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "Itinerary": {
              "title": {
                "literalString": "My Awesome Trip"
              },
              "subheading": {
                "literalString": "A 3-day adventure"
              },
              "imageChildId": "image1",
              "days": [
                {
                  "title": {
                    "literalString": "Day 1"
                  },
                  "subtitle": {
                    "literalString": "Arrival and Exploration"
                  },
                  "description": {
                    "literalString": "Welcome to the city!"
                  },
                  "imageChildId": "image2",
                  "entries": [
                    {
                      "title": {
                        "literalString": "Check-in to Hotel"
                      },
                      "bodyText": {
                        "literalString": "Check-in to your hotel and relax."
                      },
                      "time": {
                        "literalString": "3:00 PM"
                      },
                      "type": "accommodation",
                      "status": "noBookingRequired"
                    }
                  ]
                }
              ]
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
        },
        {
          "id": "image2",
          "component": {
            "Image": {
              "url": {
                "literalString": "assets/travel_images/brooklyn_bridge_new_york.jpg"
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final itineraryData = ItineraryData.fromMap(
      context.data as Map<String, Object?>,
    );

    final ValueNotifier<String?> titleNotifier = context.dataContext
        .subscribeToString(itineraryData.title);
    final ValueNotifier<String?> subheadingNotifier = context.dataContext
        .subscribeToString(itineraryData.subheading);
    final Widget imageChild = context.buildChild(itineraryData.imageChildId);

    return ItineraryWidget(
      titleNotifier: titleNotifier,
      subheadingNotifier: subheadingNotifier,
      imageChild: imageChild,
      days: itineraryData.days,
      widgetId: context.id,
      buildChild: context.buildChild,
      dispatchEvent: context.dispatchEvent,
      dataContext: context.dataContext,
    );
  },
);
