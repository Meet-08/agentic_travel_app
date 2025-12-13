import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:travel_app/src/utils.dart';

class InformationCardWidget extends StatelessWidget {
  final Widget? imageChild;
  final ValueNotifier<String?> titleNotifier;
  final ValueNotifier<String?> subtitleNotifier;
  final ValueNotifier<String?> bodyNotifier;

  const InformationCardWidget({
    super.key,
    this.imageChild,
    required this.titleNotifier,
    required this.subtitleNotifier,
    required this.bodyNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        clipBehavior: .antiAlias,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            if (imageChild != null)
              SizedBox(width: double.infinity, height: 200, child: imageChild),
            Padding(
              padding: const .all(16),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: titleNotifier,
                    builder: (context, title, _) => Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: subtitleNotifier,
                    builder: (context, subtitle, _) {
                      if (subtitle == null) return const SizedBox.shrink();
                      return Text(
                        subtitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ValueListenableBuilder(
                    valueListenable: bodyNotifier,
                    builder: (context, body, _) =>
                        MarkdownWidget(text: body ?? ''),
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

extension type InformationCardData.fromMap(Map<String, Object?> _json) {
  factory InformationCardData({
    String? imageChildId,
    required JsonMap title,
    JsonMap? subtitle,
    required JsonMap body,
  }) => InformationCardData.fromMap({
    if (imageChildId != null) 'imageChildId': imageChildId,
    'title': title,
    if (subtitle != null) 'subtitle': subtitle,
    'body': body,
  });

  String? get imageChildId => _json['imageChildId'] as String?;
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap? get subtitle => _json['subtitle'] as JsonMap?;
  JsonMap get body => _json['body'] as JsonMap;
}
