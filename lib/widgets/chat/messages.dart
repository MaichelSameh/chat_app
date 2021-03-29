import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final List<QueryDocumentSnapshot> docs = snapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(
            docs[index]["text"],
            docs[index]["userName"],
            docs[index]["userId"] == FirebaseAuth.instance.currentUser.uid,
            key: ValueKey(docs[index].id),
          ),
          itemCount: docs.length,
        );
      },
    );
  }
}
