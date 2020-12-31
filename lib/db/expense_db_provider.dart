import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_controller/models/expense_category.dart';

class ExpenseDBProvider {
  ExpenseDBProvider._();

  static final ExpenseDBProvider instance = ExpenseDBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String path = join(dataDirectory.path, "ExpenseDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Category ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name STRING"
          ")");
      await db.execute("CREATE TABLE Expense ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "category_id INTEGER,"
          "description STRING,"
          "created_at STRING,"
          "amount REAL"
          ")");
      defaultExpenseCategories.forEach((category) async {
        await db.execute(
            "INSERT INTO Category ('name') values (?)", [category.name]);
      });
      // Using batch writes
      // var categoryBatch = db.batch();
      // defaultExpenseCategories.forEach((category) {
      //   categoryBatch.insert("Category", category.toMap());
      // });
      // await categoryBatch.commit(noResult: true);
    });
  }
}
