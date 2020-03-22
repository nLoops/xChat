import 'package:flutter/material.dart';
import 'package:xchat/values/colors.dart';
import 'package:xchat/widgets/chat_appbar.dart';
import 'package:xchat/widgets/messages_list.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget();

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(flex: 2, child: ChatAppBar()), // Custom app bar for chat screen
      Expanded(
          flex: 11,
          child: Container(
            color: Palette.chatBackgroundColor,
            child: MessagesList(),
          ))
    ]);
  }
}
