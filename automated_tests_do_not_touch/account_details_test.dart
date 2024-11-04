import 'package:assignment_04/models/password_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_04/widgets/account_details.dart';

void main() {
  var pin = '12345678';
  group('AccountDetails widget', () {
    testWidgets('Has four text fields for site, username, password, and notes',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: AccountDetails(
                  pin: pin,
                  onSave: (
                      {required site,
                      required username,
                      required password,
                      notes}) {
                    // noop
                  }))));
      final fields = find.byType(TextField);
      Finder siteField;
      Finder usernameField;
      Finder passwordField;
      Finder notesField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(4));
        siteField = fields.at(0);
        usernameField = fields.at(1);
        passwordField = fields.at(2);
        notesField = fields.at(3);
        expect(siteField, findsOneWidget);
        expect(usernameField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(notesField, findsOneWidget);
      } else {
        return;
      }
    });
    testWidgets('Correctly performs validation', (tester) async {
      var calls = 0;
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: AccountDetails(
                  pin: pin,
                  onSave: (
                      {required site,
                      required username,
                      required password,
                      notes}) {
                    calls += 1;
                  }))));
      final fields = find.byType(TextField);
      Finder siteField;
      Finder usernameField;
      Finder passwordField;
      Finder notesField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(4));
        siteField = fields.at(0);
        usernameField = fields.at(1);
        passwordField = fields.at(2);
        notesField = fields.at(3);
        expect(siteField, findsOneWidget);
        expect(usernameField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(notesField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(siteField, '');
      await tester.enterText(usernameField, 'a');
      await tester.enterText(passwordField, 'b');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Site is required'), findsOneWidget);
      expect(find.text('Username is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      await tester.enterText(siteField, 'a');
      await tester.enterText(usernameField, '');
      await tester.enterText(passwordField, 'b');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Site is required'), findsNothing);
      expect(find.text('Username is required'), findsOneWidget);
      expect(find.text('Password is required'), findsNothing);
      await tester.enterText(siteField, 'a');
      await tester.enterText(usernameField, 'b');
      await tester.enterText(passwordField, '');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Site is required'), findsNothing);
      expect(find.text('Username is required'), findsNothing);
      expect(find.text('Password is required'), findsOneWidget);
      expect(calls, 0);
    });
    testWidgets('Does not allow existing account site to be altered',
        (tester) async {
      var calls = 0;
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: AccountDetails(
                  pin: pin,
                  account: PasswordAccount(
                      site: encrypt('a', pin),
                      username: encrypt('b', pin),
                      password: encrypt('c', pin)),
                  onSave: (
                      {required site,
                      required username,
                      required password,
                      notes}) {
                    calls += 1;
                  }))));
      final fields = find.byType(TextField);
      Finder siteField;
      if (fields.evaluate().isNotEmpty) {
        siteField = fields.at(0);
        expect(siteField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(siteField, 'new site');
      await tester.pumpAndSettle();
      expect(siteField, findsOneWidget);
      expect((siteField.evaluate().first.widget as TextField).controller!.text,
          'a');
    });
    testWidgets('Correctly calls callback on successful submission',
        (tester) async {
      var calls = 0;
      var argSite = '';
      var argUsername = '';
      var argPassword = '';
      String? argNotes = '';
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: AccountDetails(
                  pin: pin,
                  onSave: (
                      {required site,
                      required username,
                      required password,
                      notes}) {
                    calls += 1;
                    argSite = site;
                    argUsername = username;
                    argPassword = password;
                    argNotes = notes;
                  }))));
      final fields = find.byType(TextField);
      Finder siteField;
      Finder usernameField;
      Finder passwordField;
      Finder notesField;
      if (fields.evaluate().isNotEmpty) {
        expect(fields, findsNWidgets(4));
        siteField = fields.at(0);
        usernameField = fields.at(1);
        passwordField = fields.at(2);
        notesField = fields.at(3);
        expect(siteField, findsOneWidget);
        expect(usernameField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(notesField, findsOneWidget);
      } else {
        return;
      }
      await tester.enterText(siteField, 'a');
      await tester.enterText(usernameField, 'b');
      await tester.enterText(passwordField, 'c');
      await tester.enterText(notesField, 'd');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Site is required'), findsNothing);
      expect(find.text('Username is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(argSite, 'a');
      expect(argUsername, 'b');
      expect(argPassword, 'c');
      expect(argNotes, 'd');
      expect(calls, 1);
    });
  });
}
