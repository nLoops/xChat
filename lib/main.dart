import 'package:flutter/material.dart';
import 'package:xchat/ui/chat_list_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xChat',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: ChatList(),
    );
  }
}

