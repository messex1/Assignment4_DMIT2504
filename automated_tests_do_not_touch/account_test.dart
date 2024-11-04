import 'package:assignment_04/data/password_account_db_manager.dart';
import 'package:assignment_04/models/password_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:assignment_04/pages/account.dart';

void main() {
  const pin = '12345678';

  late Database db;
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });
  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE accounts (site TEXT PRIMARY KEY, username TEXT, password TEXT, notes TEXT)');
    });
  });
  tearDown(() async {
    await db.delete('accounts');
    await db.close();
  });
  group('AccountPage widget', () {
    testWidgets(
        'Correctly renders the decrypted fields of the account on mount',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: AccountPage(
        pin: pin,
        dbManager: PasswordAccountDbManager.instance,
        account: PasswordAccount.fromMap({
          'site': encrypt('nait.ca', pin),
          'username': encrypt('jdoe', pin),
          'password': encrypt('test1234', pin),
        }),
        onSave: (pa) {
          // noop
        },
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('nait.ca'), findsOneWidget);
      expect(find.text('jdoe'), findsOneWidget);
      expect(find.text('test1234'), findsOneWidget);
    });
    testWidgets(
        'Calls the onSave callback with the updated account and saves encrypted values to the db when the save button is pressed',
        (tester) async {
      var calls = 0;
      PasswordAccount? arg;
      await db.insert('accounts', {
        'site': encrypt('nait.ca', pin),
        'username': encrypt('jdoe', pin),
        'password': encrypt('test1234', pin),
      });
      PasswordAccountDbManager.instance.setDatabase(db);
      final pa = PasswordAccount.fromMap({
        'site': encrypt('nait.ca', pin),
        'username': encrypt('jdoe', pin),
        'password': encrypt('test1234', pin),
      });
      await tester.pumpWidget(MaterialApp(
          home: AccountPage(
        pin: pin,
        dbManager: PasswordAccountDbManager.instance,
        account: pa,
        onSave: (param) {
          calls += 1;
          arg = param;
        },
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), 'new username');
      await tester.enterText(find.byType(TextField).at(2), 'new password');
      await tester.enterText(find.byType(TextField).at(3), 'new notes');
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final newSavedSite = await db.query('accounts');
      expect(calls, equals(1));
      expect(newSavedSite[0]['username'], encrypt('new username', pin));
      expect(newSavedSite[0]['password'], encrypt('new password', pin));
      expect(newSavedSite[0]['notes'], encrypt('new notes', pin));
      expect(arg!.toMap(), pa.toMap());
    });
    testWidgets(
        'Calls the onSave callback with the new account and saves encrypted values to the db when the save button is pressed',
        (tester) async {
      var calls = 0;
      PasswordAccount? arg;
      PasswordAccountDbManager.instance.setDatabase(db);
      await tester.pumpWidget(MaterialApp(
          home: AccountPage(
        pin: pin,
        dbManager: PasswordAccountDbManager.instance,
        account: null,
        onSave: (param) {
          calls += 1;
          arg = param;
        },
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'new site');
      await tester.enterText(find.byType(TextField).at(1), 'new username');
      await tester.enterText(find.byType(TextField).at(2), 'new password');
      await tester.enterText(find.byType(TextField).at(3), 'new notes');
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final newSavedSite = await db.query('accounts');
      expect(calls, equals(1));
      expect(newSavedSite[0]['site'], encrypt('new site', pin));
      expect(newSavedSite[0]['username'], encrypt('new username', pin));
      expect(newSavedSite[0]['password'], encrypt('new password', pin));
      expect(newSavedSite[0]['notes'], encrypt('new notes', pin));
      expect(arg!.toMap(), {
        'site': encrypt('new site', pin),
        'username': encrypt('new username', pin),
        'password': encrypt('new password', pin),
        'notes': encrypt('new notes', pin)
      });
    });
    testWidgets(
        'Deletes the account from the db when the delete button is pressed',
        (tester) async {
      var calls = 0;
      PasswordAccount? arg;
      await db.insert('accounts', {
        'site': encrypt('nait.ca', pin),
        'username': encrypt('jdoe', pin),
        'password': encrypt('test1234', pin),
      });
      PasswordAccountDbManager.instance.setDatabase(db);
      final pa = PasswordAccount.fromMap({
        'site': encrypt('nait.ca', pin),
        'username': encrypt('jdoe', pin),
        'password': encrypt('test1234', pin),
      });
      await tester.pumpWidget(MaterialApp(
          home: AccountPage(
        pin: pin,
        dbManager: PasswordAccountDbManager.instance,
        account: pa,
        onSave: (param) {
          calls += 1;
          arg = param;
        },
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton).last);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final accounts = await db.query('accounts');
      expect(accounts, isEmpty);
      expect(calls, equals(1));
      expect(arg, null);
    });
  });
}
