import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:travel_app/src/assets__image.dart';
import 'package:travel_app/src/catalog.dart';
import 'package:travel_app/src/constants.dart';
import 'package:travel_app/src/widgets/conversation.dart';

Future<void> loadImagesJson() async {
  imagesJson = await assetsImageCatalogJson();
}

class TravelPlannerScreen extends StatefulWidget {
  final ContentGenerator contentGenerator;

  const TravelPlannerScreen({super.key, required this.contentGenerator});

  @override
  State<TravelPlannerScreen> createState() => _TravelPlannerScreenState();
}

class _TravelPlannerScreenState extends State<TravelPlannerScreen>
    with AutomaticKeepAliveClientMixin {
  late final GenUiConversation _uiConversation;
  late final StreamSubscription<ChatMessage> _userMessageSubscription;

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _uiConversation = GenUiConversation(
      contentGenerator: widget.contentGenerator,
      genUiManager: GenUiManager(catalog: travelAppCatalog),
      onSurfaceUpdated: (update) {
        _scrollToBottom();
      },
      onSurfaceAdded: (update) {
        _scrollToBottom();
      },
      onTextResponse: (text) {
        if (!mounted) return;
        if (text.isNotEmpty) {
          _scrollToBottom();
        }
      },
    );
  }

  @override
  void dispose() {
    _userMessageSubscription.cancel();
    _uiConversation.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _triggerInference(ChatMessage message) async {
    await _uiConversation.sendRequest(message);
  }

  void _sendPrompt(String text) {
    if (_uiConversation.isProcessing.value || text.trim().isEmpty) return;
    _scrollToBottom();
    _textController.clear();
    _triggerInference(UserMessage.text(text));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ValueListenableBuilder(
                  valueListenable: _uiConversation.conversation,
                  builder: (context, messages, child) => Conversation(
                    messages: messages,
                    host: _uiConversation.host,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const .all(8.0),
              child: ValueListenableBuilder(
                valueListenable: _uiConversation.isProcessing,
                builder: (context, isThinking, child) => _ChatInput(
                  controller: _textController,
                  isThinking: isThinking,
                  onSend: _sendPrompt,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.isThinking,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isThinking;
  final void Function(String) onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(25.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isThinking,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enter your prompt...',
                ),
                onSubmitted: isThinking ? null : onSend,
              ),
            ),
            if (isThinking)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
            else
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => onSend(controller.text),
              ),
          ],
        ),
      ),
    );
  }
}
