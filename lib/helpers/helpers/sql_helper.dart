import 'package:sqflite/sqflite.dart' as sql;


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
        totalProgress TEXT NOT NULL,
        totalTime TEXT NOT NULL,
        PRIMARY KEY (emailU, name))""");
    await database.execute("""CREATE TABLE IF NOT EXISTS notesU(
        id INTEGER AUTOINCREMENT,
        emailU TEXT NOT NULL,
        category TEXT NOT NULL
        name TEXT NOT NULL,
        dateIni TEXT NOT NULL,
        dateFin TEXT NOT NULL,
        progress TEXT NOT NULL,
        PRIMARY KEY (id, emailU, category))""");
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
}