import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sqflite/sqflite.dart';

import '../model/models.dart';
import '../widgets/widgets.dart';
import 'helpers.dart';

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
        iconColor INTEGER NOT NULL,
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

  //Get users categories
  static Future<List<CardItem>?> getUserCategories(BuildContext context, String email) async {
    AppLocalizations words = AppLocalizations.of(context)!;

    final db = await SQLHelper.db();
    List<CardItem> categories = [];
    List<Map<String, dynamic>> categoriesU = await db.query('categoriesU', where: "emailU = ?", whereArgs: [email]);

    if(categoriesU.isNotEmpty) {
      for (Map<String, dynamic> category in categoriesU) {
        List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM notesU WHERE emailU = ? AND category = ?',
            [email, category['name']],
        );
        int? countTareas = Sqflite.firstIntValue(result);
        String tareas = countTareas! == 1
          ? "$countTareas ${words.task}"
          : "$countTareas ${words.tasks}";

        categories.add(CardItem(IconDataHelper.getIconData(category['icon']), MaterialColorHelper.getMaterialColor(category['iconColor']), 
          category['name'], tareas, category['totalProgress'], category['totalTime']));
      }
      return categories;
    }
    return null;
  }

  static Future<int> deleteUserCategory(String email, String nameCategory) async {
    final db = await SQLHelper.db();

    final id = await db.delete('categoriesU', where: "emailU = ? AND name = ?", whereArgs: [email, nameCategory]);

    return id;
  }
}