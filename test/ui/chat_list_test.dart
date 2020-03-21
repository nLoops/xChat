import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/ui/chat_list_widget.dart';
import 'package:xchat/ui/chat_widget.dart';

void main(){
  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body: const ChatList()
    ),
  );

  testWidgets('ChatList UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app);
    expect(find.byType(ChatWidget),findsOneWidget);
    expect(find.byType(PageView),findsOneWidget);

  });
}