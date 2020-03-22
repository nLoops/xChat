import 'package:flutter/material.dart';
import 'package:xchat/ui/chat_list_widget.dart';
import 'package:xchat/values/colors.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xChat',
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
        primaryColorDark: Palette.primaryDark,
        accentColor: Palette.secondaryColor
      ),
      home: ChatList(),
    );
  }
}

