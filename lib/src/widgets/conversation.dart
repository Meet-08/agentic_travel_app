import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

typedef UserPromptBuilder =
    Widget Function(BuildContext context, UserMessage message);

typedef UserUiInteractionBuilder =
    Widget Function(BuildContext context, UserUiInteractionMessage message);

class Conversation extends StatelessWidget {
  final List<ChatMessage> messages;
  final GenUiHost host;
  final UserPromptBuilder? userPromptBuilder;
  final UserUiInteractionBuilder? userUiInteractionBuilder;
  final bool showInternalMessages;
  final ScrollController? scrollController;

  const Conversation({
    super.key,
    required this.messages,
    this.userPromptBuilder,
    this.userUiInteractionBuilder,
    this.showInternalMessages = false,
    this.scrollController,
    required this.host,
  });

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> renderedMessages = messages.where((message) {
      if (showInternalMessages) {
        return true;
      }
      return message is! InternalMessage && message is! ToolResponseMessage;
    }).toList();

    return ListView.builder(
      controller: scrollController,
      itemCount: renderedMessages.length,
      itemBuilder: (context, index) {
        final ChatMessage message = renderedMessages[index];
        switch (message) {
          case InternalMessage():
            return InternalMessageWidget(content: message.text);
          case UserMessage():
            return userPromptBuilder != null
                ? userPromptBuilder!(context, message)
                : ChatMessageWidget(
                    text: message.parts
                        .whereType<TextPart>()
                        .map((part) => part.text)
                        .join('\n'),
                    icon: Icons.person,
                    alignment: MainAxisAlignment.end,
                  );
          case UserUiInteractionMessage():
            return userUiInteractionBuilder != null
                ? userUiInteractionBuilder!(context, message)
                : const SizedBox.shrink();
          case AiTextMessage():
            final String text = message.parts
                .whereType<TextPart>()
                .map((part) => part.text)
                .join('\n');
            if (text.trim().isEmpty) {
              return const SizedBox.shrink();
            }
            return ChatMessageWidget(
              text: text,
              icon: Icons.smart_toy_outlined,
              alignment: MainAxisAlignment.start,
            );
          case ToolResponseMessage():
            return InternalMessageWidget(content: message.results.toString());
          case AiUiMessage():
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GenUiSurface(
                key: message.uiKey,
                host: host,
                surfaceId: message.surfaceId,
              ),
            );
        }
      },
    );
  }
}
