import 'package:flutter/material.dart';
import 'package:xchat/widgets/chat_appbar.dart';
import 'package:xchat/widgets/input_widget.dart';
import 'package:xchat/widgets/messages_list.dart';

class ChatWidget extends StatefulWidget {

  const ChatWidget();

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ChatAppBar(), // Custom app bar for chat screen
            body: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  MessagesList(), //Chat list
                  InputWidget() // The input widget
                ],
              ),
            ])));
  }
}
