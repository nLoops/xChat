import 'package:flutter/material.dart';
import 'package:xchat/widgets/chat_message.dart';

class MessagesList extends StatelessWidget {
  final ScrollController listScrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => ChatMessage(index),
          itemCount: 20,
          reverse: true,
          controller: listScrollController,
        ));
  }
}
