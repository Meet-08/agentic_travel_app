import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary.schema.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary_data.dart';
import 'package:travel_app/src/utils.dart';
import 'package:travel_app/src/widgets/dismiss_notification.dart';

class ItineraryEntry extends StatelessWidget {
  final ItineraryEntryData data;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  const ItineraryEntry({
    super.key,
    required this.data,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  IconData _getIconForType(ItineraryEntryType type) {
    switch (type) {
      case ItineraryEntryType.accommodation:
        return Icons.hotel;
      case ItineraryEntryType.transport:
        return Icons.train;
      case ItineraryEntryType.activity:
        return Icons.local_activity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ValueNotifier<String?> titleNotifier = dataContext.subscribeToString(
      data.title,
    );
    final ValueNotifier<String?> subtitleNotifier = dataContext
        .subscribeToString(data.subtitle);
    final ValueNotifier<String?> bodyTextNotifier = dataContext
        .subscribeToString(data.bodyText);
    final ValueNotifier<String?> addressNotifier = dataContext
        .subscribeToString(data.address);
    final ValueNotifier<String?> timeNotifier = dataContext.subscribeToString(
      data.time,
    );
    final ValueNotifier<String?> totalCostNotifier = dataContext
        .subscribeToString(data.totalCost);
    return Padding(
      padding: const .symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(_getIconForType(data.type), color: theme.primaryColor),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: titleNotifier,
                        builder: (context, title, _) => Text(
                          title ?? '',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    if (data.status == ItineraryEntryStatus.chosen)
                      const Icon(Icons.check_circle, color: Colors.green)
                    else if (data.status == ItineraryEntryStatus.choiceRequired)
                      ValueListenableBuilder(
                        valueListenable: titleNotifier,
                        builder: (context, title, _) => FilledButton(
                          onPressed: () {
                            final JsonMap? actionData =
                                data.choiceRequiredAction;
                            if (actionData == null) return;
                            final actionName = actionData['name'] as String;
                            final List<Object?> contextDefinition =
                                (actionData['context'] as List<Object?>?) ??
                                <Object>[];
                            final JsonMap resolvedContext = resolveContext(
                              dataContext,
                              contextDefinition,
                            );
                            dispatchEvent(
                              UserActionEvent(
                                name: actionName,
                                sourceComponentId: widgetId,
                                context: resolvedContext,
                              ),
                            );
                            DismissNotification().dispatch(context);
                          },
                          child: const Text("Choose"),
                        ),
                      ),
                  ],
                ),
                OptionalValueBuilder(
                  listenable: subtitleNotifier,
                  builder: (context, subtitle) {
                    return Padding(
                      padding: const .only(top: 4.0),
                      child: Text(subtitle, style: theme.textTheme.bodySmall),
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16.0),
                    const SizedBox(width: 4.0),
                    ValueListenableBuilder(
                      valueListenable: timeNotifier,
                      builder: (context, time, _) =>
                          Text(time ?? '', style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
                OptionalValueBuilder(
                  listenable: addressNotifier,
                  builder: (context, address) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 16.0),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              address,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                OptionalValueBuilder(
                  listenable: totalCostNotifier,
                  builder: (context, totalCost) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_money, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(totalCost, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                ValueListenableBuilder<String?>(
                  valueListenable: bodyTextNotifier,
                  builder: (context, bodyText, _) =>
                      MarkdownWidget(text: bodyText ?? ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
