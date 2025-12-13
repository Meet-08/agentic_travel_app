import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class TrailheadWidget extends StatelessWidget {
  final List<JsonMap> topics;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  const TrailheadWidget({
    super.key,
    required this.topics,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: topics.map((topicRef) {
          final notifier = dataContext.subscribeToString(topicRef);
          return ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, topic, child) {
              if (topic == null) return const SizedBox.shrink();

              return InputChip(
                label: Text(topic),
                onPressed: () {
                  final name = action['name'] as String;
                  final List<Object?> contextDefinition =
                      (action['context'] as List<Object?>?) ?? <Object?>[];
                  final JsonMap resolvedContext = resolveContext(
                    dataContext,
                    contextDefinition,
                  );
                  resolvedContext['topic'] = topic;

                  dispatchEvent(
                    UserActionEvent(
                      name: name,
                      sourceComponentId: widgetId,
                      context: resolvedContext,
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

extension type TrailheadData.fromMap(Map<String, Object?> _json) {
  factory TrailheadData({
    required List<JsonMap> topics,
    required JsonMap action,
  }) => TrailheadData.fromMap({'topics': topics, 'action': action});

  List<JsonMap> get topics => (_json['topics'] as List).cast<JsonMap>();
  JsonMap get action => _json['action'] as JsonMap;
}
