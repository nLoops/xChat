import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/ui/register_widget.dart';

void main(){
  const MaterialApp app = MaterialApp(
    home: RegisterWidget(),
  );

  testWidgets('Register Widget UI test', (WidgetTester tester) async{
    //await tester.pumpWidget(app);

    //expect(find.byType(PageView), findsOneWidget);
    //expect(find.byType(CircleIndicator), findsNWidgets(2));
    //expect(find.byType(ButtonTheme), findsOneWidget);
  });
}