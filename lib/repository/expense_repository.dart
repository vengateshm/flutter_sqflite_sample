import 'package:expense_controller/db/expense_db_provider.dart';
import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:sqflite/sqflite.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseCategory>> getAllExpenseCategories();

  Future<List<Expense>> getAllExpenses();

  Future<void> addExpense(
      int categoryId, String description, String createdAt, double amount);

  Future<ExpenseCategory> getExpenseCategoryById(int categoryId);

  deleteExpense(int expenseId);

  Future<void> addExpenseCategory(String categoryName);
}

class ExpenseRepositoryImpl extends ExpenseRepository {
  @override
  Future<void> addExpense(int categoryId, String description, String createdAt,
      double amount) async {
    final db = await ExpenseDBProvider.instance.database;
    Expense expense = Expense(categoryId, description, createdAt, amount);
    await db.insert("Expense", expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final db = await ExpenseDBProvider.instance.database;
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

  @override
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

  @override
  Future<ExpenseCategory> getExpenseCategoryById(int categoryId) async {
    final db = await ExpenseDBProvider.instance.database;
    var results =
        await db.query("Category", where: "id = ?", whereArgs: [categoryId]);
    return results.isNotEmpty ? ExpenseCategory.fromMap(results.first) : null;
  }

  @override
  deleteExpense(int expenseId) async {
    final db = await ExpenseDBProvider.instance.database;
    db.delete("Expense", where: "id = ?", whereArgs: [expenseId]);
  }

  @override
  Future<void> addExpenseCategory(String categoryName) async {
    final db = await ExpenseDBProvider.instance.database;
    ExpenseCategory expenseCategory = ExpenseCategory(categoryName);
    await db.insert("Category", expenseCategory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
