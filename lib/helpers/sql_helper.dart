import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/models.dart';

class SQLHelper {
  static const _databaseName = "TodoApp.db";
  static const _databaseVersion = 1;

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS users(
        email TEXT PRIMARY KEY NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL)""");
    await database.execute("""CREATE TABLE IF NOT EXISTS categoriesU(
        emailU TEXT NOT NULL,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        iconColor TEXT NOT NULL,
        totalProgress TEXT NOT NULL,
        totalTime TEXT NOT NULL,
        PRIMARY KEY (emailU, name))""");
    await database.execute("""CREATE TABLE IF NOT EXISTS notesU(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emailU TEXT NOT NULL,
        category TEXT NOT NULL,
        name TEXT NOT NULL,
        dateIni TEXT NOT NULL,
        dateFin TEXT NOT NULL,
        progress TEXT NOT NULL,
        UNIQUE (id, emailU, category))""");
  }

  static Future<void> cleanDatabase() async {
    try{
      final database = await db();
      await database.transaction((txn) async {
        var batch = txn.batch();
        batch.delete('users');
        batch.delete('categoriesU');
        batch.delete('notesU');
        await batch.commit();
      });
    } catch(error){
      throw Exception('DbBase.cleanDatabase: $error');
    }
  }

  //Register de user
  static Future<int> insertNewUser(AppLocalizations words, String email, String username, String encryptPassword) async {
    final db = await SQLHelper.db();

    final data = {'email': email, 'username': username, 'password': encryptPassword};
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    //Set the 5 default categories tu the user
    final List<Map<String, dynamic>> dataCList = [
      {'emailU': email, 'name': words.categoryJob, 'icon': "Icons.work_outlined", 'iconColor': "Colors.grey", 'totalProgress': "0", 'totalTime': "0"},
      {'emailU': email, 'name': words.categorySports, 'icon': "Icons.sports_soccer_outlined", 'iconColor': 'Colors.lightBlue', 'totalProgress': "0", 'totalTime': "0"},
      {'emailU': email, 'name': words.categoryReading, 'icon': "Icons.book_outlined", 'iconColor': 'Colors.red', 'totalProgress': "0", 'totalTime': "0"},
      {'emailU': email, 'name': words.categoryTravel, 'icon': "Icons.flight_outlined", 'iconColor': 'Colors.green', 'totalProgress': "0", 'totalTime': "0"},
      {'emailU': email, 'name': words.categoryGeneral, 'icon': "Icons.check_box_outline_blank_outlined", 'iconColor': 'Colors.amber', 'totalProgress': "0", 'totalTime': "0"},
    ];

    for (var dataC in dataCList) {
      await db.insert('categoriesU', dataC,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }

    return id;
  }

  //Check if user already exists
  static Future<UserModel?> checkUserExists(String email) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> users = await db.query('users', where: "email = ?", whereArgs: [email], limit: 1);
    if(users.isNotEmpty) {
      return UserModel(
        email: users[0]["email"], 
        username: users[0]["username"], 
        password: users[0]["password"]
      );
    }
    return null;
  }
}