import 'package:flutter/material.dart';
import 'package:xchat/ui/chat_widget.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        ChatWidget(),
        ChatWidget(),
        ChatWidget()
      ],
    );
  }
}
