import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_messages.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: [
          DropdownButton(
            underline: null,
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Logout", style: TextStyle(color: Colors.white)),
                  ],
                ),
                value: "Logout",
              ),
            ],
            onChanged: (itemIdentifier) async {
              if (itemIdentifier == "Logout") {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
