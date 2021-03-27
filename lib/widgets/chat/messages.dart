import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          itemBuilder: (ctx, index) => Container(
            padding: EdgeInsets.all(8),
            child: Text(docs[index]["text"]),
          ),
          itemCount: docs.length,
        );
      },
    );
  }
}
