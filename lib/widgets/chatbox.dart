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
        Container(
          margin: EdgeInsets.only(right: 16),
          child: sender == 'bot'
              ? CircleAvatar(
                  child: Text(sender[0]),
                )
              : null,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: sender == 'bot'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.yellow),
              child: Text(text.trim()),
            )
          ],
        ))
      ],
    );
  }
}
