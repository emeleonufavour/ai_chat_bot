import 'dart:async';
import 'dart:developer';
import 'package:ai_chat_bot/widgets/chatbox.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
  final List<ChatBox> messages = [];

  late OpenAI chatGPT;
  final tController = StreamController<CTResponse?>.broadcast();

  StreamSubscription? _subscription;
  void _translateEngToThai() async {
    final request = CompleteText(
        prompt: textController.text.toString(),
        maxTokens: 200,
        model: kTextDavinci3);

    chatGPT
        .onCompletionStream(request: request)
        .asBroadcastStream()
        .listen((res) {
      tController.sink.add(res);
      log(res.toString());
    }).onError((err) {
      print("$err");
    });
  }

  void _sendMessage() async {
    ChatBox message = ChatBox(sender: 'user', text: textController.text);

    setState(() {
      messages.insert(0, message);
    });
    textController.clear();
    final tController = StreamController<CTResponse?>.broadcast();

    // final request = CompleteText(
    //     prompt: translateEngToThai(word: message.text.toString()),
    //     model: kTextDavinci3,
    //     maxTokens: 200);

    // _subscription =
    //     chatGPT.onCompletionStream(request: request).listen((event) {
    //   ChatBox botText = ChatBox(sender: 'bot', text: event!.choices[0].text);
    //   log(event.choices[0].text);
    //   log(botText.text);

    //   setState(() {
    //     messages.insert(0, botText);
    //   });
    // });
  }

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: '',
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 5),
            connectTimeout: const Duration(seconds: 5)),
        isLogger: true);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    _subscription?.cancel();
    tController.close();
    chatGPT.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'AI assistant',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10).copyWith(top: 30),
                  height: size.height * (2 / 2.5),
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //messages
                      Expanded(
                          child: ListView.builder(
                        padding: Vx.m8,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return messages[index];
                        },
                      )),
                      //textfield
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, right: 10, left: 10),
                        child: SizedBox(
                            width: double.maxFinite,
                            child: CupertinoTextField(
                              controller: textController,
                              placeholder: 'Send a message',
                              style: TextStyle(color: Colors.black),
                              //send button
                              suffix: GestureDetector(
                                onTap: () {
                                  return _sendMessage();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        shape: BoxShape.circle),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: Colors.blue,
                                      ),
                                    )),
                              ),
                              onSubmitted: (value) {
                                return _sendMessage();
                              },
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25)),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
