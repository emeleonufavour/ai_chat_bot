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
          child: CircleAvatar(
            child: Text(sender[0]),
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(text),
            )
          ],
        ))
      ],
    );
  }
}
