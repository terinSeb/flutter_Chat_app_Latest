import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  const MessageBubble({super.key, required this.message, required this.isMe});
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isMe
                  ? Colors.grey[300]
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12))),
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Text(
            message,
            style: TextStyle(
                color: isMe
                    ? Colors.black
                    : Theme.of(context).secondaryHeaderColor),
          ),
        ),
      ],
    );
  }
}
