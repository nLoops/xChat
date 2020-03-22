import 'package:flutter/material.dart';
import 'package:xchat/ui/chat_widget.dart';
import 'package:xchat/widgets/chat_bottom_sheet.dart';
import 'package:xchat/widgets/input_widget.dart';

class ChatList extends StatefulWidget {
  const ChatList();

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  var controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                Expanded(
                    child: PageView(
                  children: <Widget>[ChatWidget(), ChatWidget(), ChatWidget()],
                )),
                Container(
                    child: GestureDetector(
                        child: InputWidget(),
                        onPanUpdate: (details) {
                          if (details.delta.dy < 0) {
                            _scaffoldKey.currentState
                                .showBottomSheet<Null>((BuildContext context) {
                              return ChatBottomSheet();
                            });
                          }
                        }))
              ],
            )));
  }
}
