import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/widgets/chat_bottom_sheet.dart';
import 'package:xchat/widgets/chat_row_widget.dart';
import 'package:xchat/widgets/navigation_bill_widget.dart';

void main(){
  MaterialApp app = MaterialApp(
    home: ChatBottomSheet(),
  );

  testWidgets('Bottom Sheet UI Test', (WidgetTester tester) async{

    await tester.pumpWidget(app);

    expect(find.byType(NavigationPillWidget), findsOneWidget);
    expect(find.byType(ChatRowWidget), findsNWidgets(5));
  });
}