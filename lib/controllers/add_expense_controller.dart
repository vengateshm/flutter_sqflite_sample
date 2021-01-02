import 'package:expense_controller/db/expense_db_provider.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddExpenseScreenController extends GetxController {
  var expenseCategories = List<ExpenseCategory>().obs;
  Rx<ExpenseCategory> selectedExpenseCategory = Rx<ExpenseCategory>();
  var selectedDate = "Select Date".obs; // Initial value to be shown

  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    // called immediately after the widget is allocated memory
    _getAllExpenseCategories();
    super.onInit();
  }

  @override
  void onReady() {
    // called after the widget is rendered on screen
    super.onReady();
  }

  void _getAllExpenseCategories() {
    ExpenseDBProvider.instance
        .getAllExpenseCategories()
        .then((value) => onAllExpenseCategories(value));
  }

  onAllExpenseCategories(List<ExpenseCategory> value) {
    expenseCategories.clear();
    expenseCategories.addAll(value);
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    descriptionController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void setSelectedExpenseCategory(ExpenseCategory category) {
    selectedExpenseCategory.value = category;
  }

  void setSelectedDateTime(DateTime dateTime) {
    var month;
    if (dateTime.month > 0 && dateTime.month < 10) {
      month = "0${dateTime.month}";
    } else {
      month = "${dateTime.month}";
    }
    var day;
    if (dateTime.day > 0 && dateTime.month < 10) {
      day = "0${dateTime.day}";
    } else {
      day = "${dateTime.day}";
    }
    String date = "${dateTime.year}-$month-$day";
    selectedDate.value = date;
  }

  void resetAllFields() {
    selectedDate.value = "Select Date";
    selectedExpenseCategory.value = null;
    descriptionController.clear();
    amountController.clear();
  }
}
