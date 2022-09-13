// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter chat'),
        actions: [
          DropdownButton(
              icon: const Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Logout')
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat/nQKx3oO8Ns3toiaOeu1b/message')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircleAvatar(),
            );
          }
          final documnets = snapshot.data!.docs;
          return ListView.builder(
              itemCount: documnets.length,
              itemBuilder: (ctx, index) => Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(documnets[index]['text']),
                  ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chat/nQKx3oO8Ns3toiaOeu1b/message')
              .add({'text': 'This was added by plus button'});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
