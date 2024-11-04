import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  var hash = 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f';
  group('CheckPin widget', () {
    testWidgets('Has one text field for pin', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: CheckPin(onCheckPin: (isStored, pin) {
        //noop
      }))));
      final fields = find.byType(TextField);
      Finder pinField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(1));
        pinField = fields.first;
        expect(pinField, findsOneWidget);
      } else {
        return;
      }
    });
    testWidgets('Correctly performs validation', (tester) async {
      var calls = 0;
      final Map<String, Object> values = <String, Object>{'pin': hash};
      SharedPreferences.setMockInitialValues(values);
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: CheckPin(onCheckPin: (isStored, pin) {
        calls += 1;
      }))));
      final fields = find.byType(TextField);
      Finder pinField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(1));
        pinField = fields.first;
        expect(pinField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(pinField, '');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Invalid pin, try again'), findsOneWidget);

      expect(calls, 0);
    });
    testWidgets('Correctly calls callback on successful submission',
        (tester) async {
      var calls = 0;
      var arg = '';
      final Map<String, Object> values = <String, Object>{'pin': hash};
      SharedPreferences.setMockInitialValues(values);
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: CheckPin(onCheckPin: (isStored, pin) {
        arg = pin;
        calls += 1;
      }))));
      final fields = find.byType(TextField);
      Finder pinField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(1));
        pinField = fields.first;
        expect(pinField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(pinField, '12345678');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(arg, '12345678');
    });
  });
}
