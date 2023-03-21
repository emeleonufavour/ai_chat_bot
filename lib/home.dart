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

  void _talkToChatGPT() async {
    ChatBox message = ChatBox(sender: 'user', text: textController.text);
    setState(() {
      messages.insert(0, message);
    });

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
      ChatBox GPTtext = ChatBox(sender: 'bot', text: result!);
      bool alreadyExists = messages.any((item) => item.text == GPTtext.text);

      if (!alreadyExists) {
        setState(() {
          messages.insert(0, GPTtext);
        });
      }

      log(GPTtext.text);
    }).onError((err) {
      log("$err");
    });
  }

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: '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',
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 10),
            connectTimeout: const Duration(seconds: 10)),
        isLogger: true);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();

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
              //heading
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
                  padding: const EdgeInsets.all(10).copyWith(top: 30),
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
                      //the result card gotten from pub dev
                      // _resultCard(size, tController),

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
                                  // return _sendMessage();
                                  return _talkToChatGPT();
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
                                return _talkToChatGPT();
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

Widget _resultCard(Size size, StreamController<CTResponse?> tController) {
  return StreamBuilder<CTResponse?>(
    stream: tController.stream,
    builder: (context, snapshot) {
      final text = snapshot.data?.choices.last.text ??
          "Hey there. I am your AI chatbot. Ask me sth";
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 32.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.bottomCenter,
        width: size.width * .86,
        height: size.height * .3,
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              SizedBox(
                width: size.width,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.copy_outlined,
                      color: Colors.grey,
                      size: 22.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.grey,
                        size: 22.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
