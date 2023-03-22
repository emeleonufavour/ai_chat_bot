import 'package:ai_chat_bot/controllers/chatcontroller.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChatController ctr = Get.put(ChatController());

  late OpenAI chatGPT;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: '', //get secret token from Open AI website
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 30),
            connectTimeout: const Duration(seconds: 30)),
        isLogger: true);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    ctr.textController.dispose();
    ctr.tController.close();
    chatGPT.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //heading
              Container(
                height: 70,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 17),
                decoration: BoxDecoration(color: Colors.grey[700]),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: SvgPicture.asset('assets/chatgpt.svg'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chat GPT',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        GetBuilder<ChatController>(
                          builder: (controller) => Container(
                            padding: const EdgeInsets.all(15),
                            child: controller.isTyping
                                ? const JumpingDots(
                                    radius: 5,
                                    innerPadding: 5,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(10).copyWith(top: 0),
                  height: size.height * (2 / 2.35),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //messages
                      GetBuilder<ChatController>(
                        builder: (controller) => Expanded(
                            child: ListView.builder(
                          padding: Vx.m8,
                          reverse: true,
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            return controller.messages[index];
                          },
                        )),
                      ),
                      //textfield
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, right: 10, left: 10),
                        child: SizedBox(
                            width: double.maxFinite,
                            child: CupertinoTextField(
                              controller: ctr.textController,
                              placeholder: 'Send a message',
                              placeholderStyle: TextStyle(color: Colors.grey),
                              style: TextStyle(color: Colors.white),
                              //send button
                              suffix: GestureDetector(
                                onTap: () {
                                  return ctr.talkToChatGPT(chatGPT);
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
                                return ctr.talkToChatGPT(chatGPT);
                              },
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
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
