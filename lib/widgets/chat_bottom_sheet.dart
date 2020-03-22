import 'package:flutter/material.dart';
import 'package:xchat/values/colors.dart';
import 'package:xchat/values/styles.dart';

import 'chat_row_widget.dart';
import 'navigation_bill_widget.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet();

  @override
  _ChatBottomSheetState createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(children: <Widget>[
              NavigationPillWidget(),
              Center(child: Text('Messages', style: Styles.textHeading)),
              SizedBox(
                height: 20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 75, right: 20),
                    child: Divider(
                      color: Palette.secondaryColor,
                    )),
                itemBuilder: (context, index) {
                  return ChatRowWidget();
                },
              )
            ])));
  }
}
