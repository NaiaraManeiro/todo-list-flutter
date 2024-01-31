import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/models.dart';
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
        isNew BOOLEAN NOT NULL,
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

  //Get users categories for the carrousel
  static Future<List<CardItem>?> getUserCategories(BuildContext context, String email) async {
    AppLocalizations words = AppLocalizations.of(context)!;

    final db = await SQLHelper.db();
    List<CardItem> categories = [];

    return await db.transaction<List<CardItem>?>( (txn) async {
      List<Map<String, dynamic>> categoriesU = await txn.query('categoriesU', where: "emailU = ? AND isNew = ?", whereArgs: [email, false]);

      if(categoriesU.isNotEmpty) {
        for (Map<String, dynamic> category in categoriesU) {
          List<Map<String, dynamic>> notes = await txn.query('notesU', where: "emailU = ? AND category = ?", whereArgs: [email, category['name']]);
          if (notes.isNotEmpty) {
            int countTareas = notes.length;
            String tareas = countTareas == 1
            ? "$countTareas ${words.task}"
            : "$countTareas ${words.tasks}";

            int percentage = 0;
            DateTime earliestDate = DateTime(1890);
            DateTime latestDate = DateTime(1890);

            for (Map<String, dynamic> note in notes) {
              percentage = percentage + int.parse(note['progress']);

              List<String> ini = note['dateIni'].split('-');    
              DateTime dateIni = DateTime(int.parse(ini[2]), int.parse(ini[1]), int.parse(ini[0]));
              if (dateIni.isAfter(earliestDate)) {
                earliestDate = dateIni;
              }

              List<String> fin = note['dateFin'].split('-');  
              DateTime dateFin = DateTime(int.parse(fin[2]), int.parse(fin[1]), int.parse(fin[0]));
              if (dateFin.isAfter(latestDate)) {
                latestDate = dateFin;
              }
            }

            Duration daysDiff = latestDate.difference(earliestDate);
            int totalMonths = daysDiff.inDays ~/ 30; 
            int remainingDays = daysDiff.inDays % 30;
            String dias = ""; 

            if (totalMonths == 0) {
              dias = daysDiff.inDays == 1
                ? "${daysDiff.inDays} ${words.day}"
                : "${daysDiff.inDays} ${words.days}";
            } else if (remainingDays == 0) {
              dias = totalMonths == 1
                ? "$totalMonths ${words.month}"
                : "$totalMonths ${words.months}";
            } else {
              String months = totalMonths == 1
                ? "$totalMonths ${words.month} "
                : "$totalMonths ${words.months} ";
              String days = daysDiff.inDays == 1
                ? "${daysDiff.inDays} ${words.day}"
                : "${daysDiff.inDays} ${words.days}";
              dias = months + days;
            }

            categories.add(CardItem(IconDataHelper.getIconData(category['icon']), MaterialColorHelper.getMaterialColor(category['iconColor']), 
              category['name'], tareas, percentage == 0 ? '0' : '${percentage/countTareas}', dias));
          } else {
            categories.add(CardItem(IconDataHelper.getIconData(category['icon']), MaterialColorHelper.getMaterialColor(category['iconColor']), 
              category['name'], "0 ${words.tasks}", category['totalProgress'], category['totalTime']));
          }
        }
        return categories;
      }
      return null;
    });
  }

  //Get users categories
  static Future<List<CardItem>?> getCategories(String email) async {
    final db = await SQLHelper.db();
    List<CardItem> categories = [];
    List<Map<String, dynamic>> categoriesU = await db.query('categoriesU', where: "emailU = ?", whereArgs: [email]);

    if(categoriesU.isNotEmpty) {
      for (Map<String, dynamic> category in categoriesU) {
        categories.add(CardItem(IconDataHelper.getIconData(category['icon']), MaterialColorHelper.getMaterialColor(category['iconColor']), 
          category['name'], "0", category['totalProgress'], category['totalTime']));
      }
      return categories;
    }
    return null;
  }

  //Delete category of user
  static Future<void> deleteUserCategory(String email, String nameCategory) async {
    final db = await SQLHelper.db();

    Map<String, dynamic> values = {
      "isNew": true,
    };

    await db.transaction((txn) async {

      await txn.update('categoriesU', values, where: "emailU = ? AND name = ?", whereArgs: [email, nameCategory]);

      //Detelete the task related to the category
      await txn.delete('notesU', where: "emailU = ? AND category = ?", whereArgs: [email, nameCategory]);
    });
  }

  //Add tasks to the user and category
  static Future<void> addTasks(String email, String nameCategory, List<TaskModel> tasks) async {
    final db = await SQLHelper.db();

    Map<String, dynamic> values = {
      "isNew": false,
    };

    await db.transaction((txn) async {
      await txn.update('categoriesU', values, where: "emailU = ? AND name = ?", whereArgs: [email, nameCategory]);

      await txn.delete('notesU', where: "emailU = ? AND category = ?", whereArgs: [email, nameCategory]);
      
      for (TaskModel task in tasks) {
        final data = {'emailU': email, 'category': nameCategory, 'name': task.name, 'dateIni': task.dateIni, 'dateFin': task.dateFin, 'progress': task.progress};
        await txn.insert('notesU', data);
      }
    });
  }

  //Get task of a category
  static Future<List<TaskModel>> getTasksCategory(String email, String nameCategory) async {
    final db = await SQLHelper.db();

    List<TaskModel> tasks = [];

    List<Map<String, dynamic>> tasksC = await db.query('notesU', where: "emailU = ? AND category = ?", whereArgs: [email, nameCategory]);

    for (Map<String, dynamic> tc in tasksC) {
      tasks.add(TaskModel(id: tc['id'], name: tc['name'], dateIni: tc['dateIni'], dateFin: tc['dateFin'], progress: tc['progress']));
    }

    return tasks;
  }

  //Update task progress
  static Future<void> updateTaskProgress(int id, String email, String nameCategory, String progress) async {
    final db = await SQLHelper.db();

    Map<String, dynamic> values = {
      "progress": progress,
    };

    await db.update('notesU', values, where: "id = ? AND emailU = ? AND category = ?", whereArgs: [id, email, nameCategory]);
  }

  //Update category progress
  static Future<int> updateCategoryProgress(String email, String nameCategory) async {
    final db = await SQLHelper.db();

    int progress = 0;

    await db.transaction((txn) async {
      List<Map<String, dynamic>> tasks = await txn.query('notesU', where: "emailU = ? AND category = ?", whereArgs: [email, nameCategory]);

      for (Map<String, dynamic> task in tasks) {
        progress = progress + int.parse(task['progress']);
      }

      progress = (progress/tasks.length).round();

      Map<String, dynamic> values = {
        "totalProgress": progress,
      };

      await txn.update('categoriesU', values, where: "emailU = ? AND name = ?", whereArgs: [email, nameCategory]);
    });

    return progress;
  }
}