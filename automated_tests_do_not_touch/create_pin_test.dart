import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment_04/widgets/create_pin.dart';

void main() {
  var hash = 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f';
  group('CreatePin widget', () {
    testWidgets('Has two text fields for pin and confirm pin', (tester) async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: CreatePin(onCreatePin: (pin) {
        //noop
      }))));
      final fields = find.byType(TextField);
      Finder pinField;
      Finder confirmPinField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(2));
        pinField = fields.at(0);
        confirmPinField = fields.at(1);
        expect(pinField, findsOneWidget);
        expect(confirmPinField, findsOneWidget);
      } else {
        return;
      }
    });
    testWidgets('Correctly performs validation', (tester) async {
      var calls = 0;
      var arg = '';
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: CreatePin(onCreatePin: (pin) {
        arg = pin;
        calls += 1;
      }))));
      final fields = find.byType(TextField);
      Finder pinField;
      Finder confirmPinField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(2));
        pinField = fields.at(0);
        confirmPinField = fields.at(1);
        expect(pinField, findsOneWidget);
        expect(confirmPinField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(pinField, '');
      await tester.enterText(confirmPinField, 'x');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Pin must be 6-10 digits'), findsOneWidget);
      expect(find.text('Pin doesn\'t match'), findsOneWidget);
      await tester.enterText(pinField, '12345678901');
      await tester.enterText(confirmPinField, '12345678901');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      if (arg.isEmpty) {
        expect(find.text('Pin must be 6-10 digits'), findsOneWidget);
        expect(calls, 0);
      } else {
        expect(calls, 1);
        expect(arg, '1234567890');
      }
    });
    testWidgets(
        'Correctly calls callback and stores hashed pin on successful submission',
        (tester) async {
      var calls = 0;
      var arg = '';
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: CreatePin(onCreatePin: (pin) {
        arg = pin;
        calls += 1;
      }))));
      final fields = find.byType(TextField);
      Finder pinField;
      Finder confirmPinField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(2));
        pinField = fields.at(0);
        confirmPinField = fields.at(1);
        expect(pinField, findsOneWidget);
        expect(confirmPinField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(pinField, '12345678');
      await tester.enterText(confirmPinField, '12345678');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(arg, '12345678');
      expect((await SharedPreferences.getInstance()).getString('pin'), hash);
    });
  });
}
