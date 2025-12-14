import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary_data.dart';
import 'package:travel_app/src/utils.dart';
import 'package:travel_app/src/widgets/itinerary_entry.dart';

class ItineraryDay extends StatelessWidget {
  final ItineraryDayData data;
  final String widgetId;
  final ChildBuilderCallback buildChild;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  const ItineraryDay({
    super.key,
    required this.data,
    required this.widgetId,
    required this.buildChild,
    required this.dispatchEvent,
    required this.dataContext,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ValueNotifier<String?> titleNotifier = dataContext.subscribeToString(
      data.title,
    );
    final ValueNotifier<String?> subtitleNotifier = dataContext
        .subscribeToString(data.subtitle);
    final ValueNotifier<String?> descriptionNotifier = dataContext
        .subscribeToString(data.description);
    final Widget imageChild = buildChild(data.imageChildId);

    return Padding(
      padding: const .symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: .all(color: Colors.grey.shade300),
          borderRadius: .circular(8.0),
        ),
        padding: const .all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                ClipRRect(
                  borderRadius: .circular(8.0),
                  child: SizedBox(height: 80, width: 80, child: imageChild),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: titleNotifier,
                        builder: (context, value, _) => Text(
                          value ?? '',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      ValueListenableBuilder(
                        valueListenable: subtitleNotifier,
                        builder: (context, value, _) => Text(
                          value ?? '',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ValueListenableBuilder(
              valueListenable: descriptionNotifier,
              builder: (context, description, _) =>
                  MarkdownWidget(text: description ?? ''),
            ),
            const SizedBox(height: 8.0),
            const Divider(),
            for (final entryData in data.entries)
              ItineraryEntry(
                data: ItineraryEntryData.fromMap(entryData),
                widgetId: widgetId,
                dispatchEvent: dispatchEvent,
                dataContext: dataContext,
              ),
          ],
        ),
      ),
    );
  }
}
