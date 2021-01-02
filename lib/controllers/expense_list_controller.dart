import 'package:expense_controller/db/expense_db_provider.dart';
import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ExpenseScreenController extends GetxController {
  List<Expense> expenses = List<Expense>().obs;
  
  @override
  void onInit() {
    _getAllExpenses();
    super.onInit();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  void _getAllExpenses() {
    ExpenseDBProvider.instance
        .getAllExpenses()
        .then((value) => onAllExpenses(value));
  }

  onAllExpenses(List<Expense> value) {
    expenses.clear();
    expenses.addAll(value);
  }

  deleteExpense(Expense expense) {
    ExpenseDBProvider.instance
        .deleteExpense(expense.id)
        .then((value) => onDeleteExpense(value, expense));
  }

  onDeleteExpense(int value, Expense expense) {
    if (expense.id != null && expense.id > 0) {
      expenses.removeWhere((element) => element.id == expense.id);
    }
    // if (expense.categoryId != null &&
    //     expense.categoryId > 0 &&
    //     expense.createdAt != null &&
    //     expense.createdAt.isNotEmpty) {
    //   expenses.removeWhere((element) =>
    //       (element.categoryId == expense.categoryId &&
    //           element.createdAt == expense.createdAt));
    // }
  }

  void addExpense(Expense expense) {
    ExpenseDBProvider.instance.addExpense(expense);
    expenses.add(expense);
  }
}
