import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment_04/pages/home.dart';
import 'package:assignment_04/widgets/create_pin.dart';

void main() {
  var hash = 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f';
  group('HomePage widget', () {
    testWidgets('Correctly checks for absence of pin', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: HomePage())));
      await tester.pumpAndSettle();
      expect(find.byType(CreatePin), findsOneWidget);
    });
    testWidgets('Correctly checks for presence of pin', (tester) async {
      final Map<String, Object> values = <String, Object>{'pin': hash};
      SharedPreferences.setMockInitialValues(values);
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: HomePage())));
      await tester.pumpAndSettle();
      expect(find.byType(CheckPin), findsOneWidget);
    });
  });
}
