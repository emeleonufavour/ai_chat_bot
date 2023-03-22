import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatBox extends StatelessWidget {
  final String sender;
  final String text;
  const ChatBox({required this.sender, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: sender == 'bot'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: sender == 'bot' ? Colors.grey[600] : Colors.blue,
                  borderRadius: sender == 'bot'
                      ? const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
              child: Text(
                text.trim(),
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ))
      ],
    );
  }
}
