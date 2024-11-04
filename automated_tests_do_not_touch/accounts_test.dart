import 'package:assignment_04/data/password_account_db_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:assignment_04/pages/accounts.dart';

void main() {
  const pin = '12345678';
  final testList = [
    {
      'site': encrypt('nait.ca', pin),
      'username': encrypt('jdoe', pin),
      'password': encrypt('test1234', pin),
    },
    {
      'site': encrypt('bank', pin),
      'username': encrypt('janey', pin),
      'password': encrypt('asdf', pin),
    },
  ];

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
  group('AccountsPage widget', () {
    testWidgets('Correctly renders the decrypted list of accounts on mount',
        (tester) async {
      db.insert('accounts', testList[0]);
      db.insert('accounts', testList[1]);
      PasswordAccountDbManager.instance.setDatabase(db);
      await tester.pumpWidget(const MaterialApp(
          home: AccountsPage(
              pin: pin, dbManager: PasswordAccountDbManager.instance)));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.textContaining('nait.ca'), findsOneWidget);
      expect(find.textContaining('jdoe'), findsOneWidget);
      expect(find.textContaining('bank'), findsOneWidget);
      expect(find.textContaining('janey'), findsOneWidget);
    });
  });
}
