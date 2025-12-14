import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary_data.dart';
import 'package:travel_app/src/widgets/dismiss_notification.dart';
import 'package:travel_app/src/widgets/itinerary_day.dart';

class ItineraryWidget extends StatelessWidget {
  final ValueNotifier<String?> titleNotifier;
  final ValueNotifier<String?> subheadingNotifier;
  final Widget imageChild;
  final List<JsonMap> days;
  final String widgetId;
  final ChildBuilderCallback buildChild;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  const ItineraryWidget({
    super.key,
    required this.titleNotifier,
    required this.subheadingNotifier,
    required this.imageChild,
    required this.days,
    required this.widgetId,
    required this.buildChild,
    required this.dispatchEvent,
    required this.dataContext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          clipBehavior: Clip.antiAlias,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return NotificationListener<DismissNotification>(
              onNotification: (notification) {
                Navigator.of(context).pop();
                return true;
              },
              child: FractionallySizedBox(
                heightFactor: 0.9,
                child: Scaffold(
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: imageChild,
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: ValueListenableBuilder<String?>(
                                valueListenable: titleNotifier,
                                builder: (context, title, _) => Text(
                                  title ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            for (final dayData in days)
                              ItineraryDay(
                                data: ItineraryDayData.fromMap(dayData),
                                widgetId: widgetId,
                                buildChild: buildChild,
                                dispatchEvent: dispatchEvent,
                                dataContext: dataContext,
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: Material(
                          color: Colors.white.withAlpha((255 * 0.8).round()),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Card(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(height: 100, width: 100, child: imageChild),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: titleNotifier,
                    builder: (context, title, _) => Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: subheadingNotifier,
                    builder: (context, subheading, _) => Text(
                      subheading ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
