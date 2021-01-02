import 'package:expense_controller/db/expense_db_provider.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:expense_controller/preferences/expense_preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreenController extends GetxController {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController monthlyExpenseLimitController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    categoryNameController.dispose();
    monthlyExpenseLimitController.dispose();
    super.onClose();
  }

  void addExpenseCategory(ExpenseCategory expenseCategory) {
    ExpenseDBProvider.instance.addExpenseCategory(expenseCategory);
    categoryNameController.clear();
  }

  void setMonthlyLimit() {
    if (monthlyExpenseLimitController.text.isNotEmpty) {
      ExpensePreferenceProvider.instance
          .setMonthlyLimit(double.parse(monthlyExpenseLimitController.text));
      //monthlyExpenseLimitController.clear() No need to clear as user can get to know the previously set limit
    }
  }
}
