import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required String email,
    @required FirebaseFirestore firestore,
  })  : email = email,
        _firestore = firestore,
        super(key: key);

  final String email;
  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('created').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        List<Widget> bubbles =
            snapshot.data.docs.reversed.map((DocumentSnapshot doc) {
          Map<String, dynamic> data = doc.data();
          String message = data['text'];
          String sender = data['sender'];
          return MessageBubble(
            sender: sender,
            text: message,
            isMe: sender == email,
          );
        }).toList();
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: bubbles,
          ),
        );
      },
    );
  }
}
