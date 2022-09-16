import 'package:chat_app_flutter/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
        // future: user.uid,
        builder: (ctx, futureSnapshot) {
      if (futureSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: ((ctx, snapshot) {
            final chatDocs = snapshot.data?.docs;

            return ListView.builder(
                reverse: true,
                itemCount: chatDocs!.length,
                itemBuilder: (ctx, index) => MessageBubble(
                      message: chatDocs[index]['text'],
                      isMe: chatDocs[index]['userId'] ==
                          user!.uid, //  futureSnapshot.data!.uid,
                      key: ValueKey(chatDocs[index].hashCode),
                    ));
          }));
    });
  }
}
