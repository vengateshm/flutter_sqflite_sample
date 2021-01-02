import 'dart:async';
import 'dart:io';

import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<List<Expense>> getAllExpenses() async {
    final db = await instance.database;
    List<Map> results = await db.query("Expense", columns: Expense.columns);
    List<Expense> expenses = new List();
    await Future.forEach(results, (result) async {
      Expense expense = Expense.fromMap(result);
      var category = await getExpenseCategoryById(expense.categoryId);
      if (category != null) {
        expense.categoryName = category.name;
      }
      expenses.add(expense);
    });
    return expenses;
  }

  Future<ExpenseCategory> getExpenseCategoryById(int categoryId) async {
    final db = await instance.database;
    var results =
        await db.query("Category", where: "id = ?", whereArgs: [categoryId]);
    return results.isNotEmpty ? ExpenseCategory.fromMap(results.first) : null;
  }

  Future<int> deleteExpense(int expenseId) async {
    final db = await ExpenseDBProvider.instance.database;
    return db.delete("Expense", where: "id = ?", whereArgs: [expenseId]);
  }

  Future<void> addExpenseCategory(ExpenseCategory expenseCategory) async {
    final db = await ExpenseDBProvider.instance.database;
    await db.insert("Category", expenseCategory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ExpenseCategory>> getAllExpenseCategories() async {
    final db = await ExpenseDBProvider.instance.database;
    List<Map> results =
        await db.query("Category", columns: ExpenseCategory.columns);
    List<ExpenseCategory> categories = new List();
    results.forEach((result) {
      ExpenseCategory category = ExpenseCategory.fromMap(result);
      categories.add(category);
    });
    return categories;
  }

  Future<void> addExpense(Expense expense) async {
    final db = await ExpenseDBProvider.instance.database;
    await db.insert("Expense", expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
