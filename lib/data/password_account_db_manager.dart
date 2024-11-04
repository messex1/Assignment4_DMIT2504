import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/password_account.dart';

class PasswordAccountDbManager {
  Database? _database;

  /// Initializes the database connection.
  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'password_accounts.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE accounts(id INTEGER PRIMARY KEY, site TEXT, username TEXT, password TEXT, notes TEXT)",
        );
      },
      version: 1,
    );
  }

  /// Inserts a new account into the database.
  Future<void> insertAccount(PasswordAccount account) async {
    await _database?.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all accounts from the database.
  Future<List<PasswordAccount>> getAccounts() async {
    final List<Map<String, dynamic>> maps = await _database?.query('accounts') ?? [];
    return List.generate(maps.length, (i) => PasswordAccount.fromMap(maps[i]));
  }

  /// Deletes an account by ID.
  Future<void> deleteAccount(int id) async {
    await _database?.delete(
      'accounts',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// Closes the database connection.
  Future<void> closeDatabase() async {
    await _database?.close();
  }
}
