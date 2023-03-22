import 'dart:async';
import 'dart:developer';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../widgets/chatbox.dart';

class ChatController extends GetxController {
  TextEditingController textController = TextEditingController();
  final tController = StreamController<CTResponse?>.broadcast();
  final List<ChatBox> _messages = [];
  bool _isTyping = false;

  get messages => _messages;
  get isTyping => _isTyping;

  void addToList(ChatBox message) {
    _messages.insert(0, message);
    update();
  }

  set isTyping(value) {
    _isTyping = value;
    update();
  }

  String removeLetterFromString(String originalString, String letterToRemove) {
    return originalString.replaceAll(letterToRemove, '');
  }

  void talkToChatGPT(OpenAI chatGPT) async {
    ChatBox message = ChatBox(sender: 'user', text: textController.text);

    _isTyping = true;
    addToList(message);

    textController.clear();

    final request = CompleteText(
        prompt: message.text.toString(), maxTokens: 200, model: kTextDavinci3);
    String? result;

    chatGPT
        .onCompletionStream(request: request)
        .asBroadcastStream()
        .listen((res) {
      tController.sink.add(res);
      result = res!.choices.last.text;
      String newResult = removeLetterFromString(result!, '?');
      ChatBox GPTtext = ChatBox(sender: 'bot', text: newResult);
      bool alreadyExists = messages.any((item) => item.text == GPTtext.text);

      if (!alreadyExists) {
        _isTyping = false;
        addToList(GPTtext);
      }

      log(GPTtext.text);
    }).onError((err) {
      log("$err");
    });
  }
}
