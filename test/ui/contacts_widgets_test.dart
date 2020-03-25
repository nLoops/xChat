import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/ui/contacts_widget.dart';
import 'package:xchat/widgets/gradient_fab.dart';
import 'package:xchat/widgets/quick_scrollbar.dart';

void main() {
  const MaterialApp app = MaterialApp(
    home: Scaffold(
      body: ContactsWidget(),
    ),
  );

  testWidgets('Contacts Widget UI test', (WidgetTester tester) async {
    // wait until widget loading
    await tester.pumpWidget(app);

    // make our assertions.
    expect(find.byType(SliverAppBar), findsOneWidget);
    expect(find.byType(SliverList), findsOneWidget);
    expect(find.byType(QuickScrollBar), findsOneWidget);
    expect(find.byType(GradientFab), findsOneWidget);
  });
}
