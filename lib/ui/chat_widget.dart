import 'package:flutter/material.dart';
import 'package:xchat/widgets/chat_appbar.dart';
import 'package:xchat/widgets/chat_bottom_sheet.dart';
import 'package:xchat/widgets/input_widget.dart';
import 'package:xchat/widgets/messages_list.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget();

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
            appBar: ChatAppBar(), // Custom app bar for chat screen
            body: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  MessagesList(), //Chat list
                  GestureDetector(
                    child: InputWidget(),
                    onPanUpdate: (details) {
                      // delta.dy > 0 would mean that the user swiped up and delta.dy < 0
                      // would mean that the user swiped down.
                      if (details.delta.dy < 0) {
                        _scaffoldKey.currentState
                            .showBottomSheet<Null>((BuildContext context) {
                          return ChatBottomSheet();
                        });
                      }
                    },
                  ) // The input widget
                ],
              ),
            ])));
  }
}
