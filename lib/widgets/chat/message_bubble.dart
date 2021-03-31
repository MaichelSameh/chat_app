import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'linkable.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String userName;
  final String userId;
  final bool isMe;

  const MessageBubble(this.message, this.userName, this.isMe, this.userId,
      {this.key})
      : super(key: key);

  Future<String> getImage() async {
    String url;
    Stream<DocumentSnapshot> docs =
        FirebaseFirestore.instance.collection("users").doc(userId).snapshots();
    await docs.first.then((value) => url = value["imageURL"]);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          // overflow: Overflow.visible,
          children: [
            buildBubbleMessage(context),
            buildUserImage(),
          ],
        ),
      ],
    );
  }

  LayoutBuilder buildBubbleMessage(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrain) => LimitedBox(
        maxWidth: constrain.maxHeight * 2 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: !isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline6.color,
                ),
              ),
              // Text(
              //   message,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     color: !isMe
              //         ? Colors.black
              //         : Theme.of(context).accentTextTheme.headline6.color,
              //   ),
              //   textAlign: !isMe ? TextAlign.end : TextAlign.start,
              // ),
              Linkable(
                message: message,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline6.color,
                ),
                textAlign: !isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserImage() {
    return Positioned(
      top: 0,
      left: !isMe ? 120 : null,
      right: isMe ? 120 : null,
      child: FutureBuilder(
        future: getImage(),
        builder: (ctx, snapshot) {
          return CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 15,
            backgroundImage:
                snapshot.hasData ? NetworkImage(snapshot.data) : null,
          );
        },
      ),
    );
  }
}
