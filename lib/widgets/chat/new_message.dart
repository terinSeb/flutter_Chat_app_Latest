import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // ignore: unnecessary_new, unused_field
  final _controller = new TextEditingController();
  // ignore: unused_element
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection('chat')
        .add({'text': enteredMessage, 'createdAt': DateTime.now()});
    _controller.clear();
  }

  var enteredMessage = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Send a message...'),
            onChanged: (value) {
              setState(() {
                enteredMessage = value;
              });
            },
          )),
          IconButton(
              onPressed: enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
