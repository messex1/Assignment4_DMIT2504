import 'package:assignment_04/data/password_account_db_manager.dart';
import 'package:assignment_04/models/password_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
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
  group('PasswordAccountDbManager', () {
    test('Creates a PasswordAccount in the db', () async {
      PasswordAccountDbManager.instance.setDatabase(db);

      await PasswordAccountDbManager.instance.createAccount(
          PasswordAccount(site: 'foo', username: 'bar', password: 'baz'));

      final accounts = await PasswordAccountDbManager.instance.getAllAccounts();

      expect(accounts.length, 1);
      expect(accounts[0].toMap(),
          {'site': 'foo', 'username': 'bar', 'password': 'baz'});
    });
    test('Updates a PasswordAccount in the db', () async {
      await db.insert('accounts', {
        'site': 'foo',
        'username': 'bar',
        'password': 'baz',
        'notes': 'some notes'
      });
      PasswordAccountDbManager.instance.setDatabase(db);
      int count = await PasswordAccountDbManager.instance.updateAccount(
          PasswordAccount(
              site: 'foo',
              username: 'newBar',
              password: 'newBaz',
              notes: 'new notes'));
      final accounts = await db.query('accounts');
      expect(count, 1);
      expect(accounts.length, 1);
      expect(accounts[0], {
        'site': 'foo',
        'username': 'newBar',
        'password': 'newBaz',
        'notes': 'new notes'
      });
    });
    test('Deletes a PasswordAccount in the db', () async {
      await db.insert('accounts', {
        'site': 'foo',
        'username': 'bar',
        'password': 'baz',
        'notes': 'some notes'
      });
      PasswordAccountDbManager.instance.setDatabase(db);
      int count = await PasswordAccountDbManager.instance.deleteAccount(
          PasswordAccount(
              site: 'foo',
              username: 'newBar',
              password: 'newBaz',
              notes: 'new notes'));
      final accounts = await db.query('accounts');
      expect(count, 1);
      expect(accounts.length, 0);
    });
    test('Returns a PasswordAccount from the db', () async {
      await db.insert('accounts', {
        'site': 'foo',
        'username': 'bar',
        'password': 'baz',
        'notes': 'some notes'
      });
      PasswordAccountDbManager.instance.setDatabase(db);

      PasswordAccount? pa =
          await PasswordAccountDbManager.instance.getAccount('foo');

      expect(pa.toMap(), {
        'site': 'foo',
        'username': 'bar',
        'password': 'baz',
        'notes': 'some notes'
      });
    });
    test('Returns all PasswordAccounts from the db', () async {
      await db.insert('accounts', {
        'site': 'foo1',
        'username': 'bar1',
        'password': 'baz1',
        'notes': 'some notes1'
      });

      await db.insert('accounts', {
        'site': 'foo2',
        'username': 'bar2',
        'password': 'baz2',
        'notes': 'some notes2'
      });
      PasswordAccountDbManager.instance.setDatabase(db);
      List<PasswordAccount> pas =
          await PasswordAccountDbManager.instance.getAllAccounts();
      expect(pas.length, 2);
      expect(pas[0].toMap(), {
        'site': 'foo1',
        'username': 'bar1',
        'password': 'baz1',
        'notes': 'some notes1'
      });
      expect(pas[1].toMap(), {
        'site': 'foo2',
        'username': 'bar2',
        'password': 'baz2',
        'notes': 'some notes2'
      });
    });
  });
}
