import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = new TextEditingController();
  String _enteredMessage = "";

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    //send a message here
    final user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _enteredMessage,
      "createdAt": Timestamp.now(),
      "userName": userData["userName"],
      "userId": user.uid,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: "Send message....."),
                onChanged: (val) {
                  setState(() {
                    _enteredMessage = val;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ));
  }
}
