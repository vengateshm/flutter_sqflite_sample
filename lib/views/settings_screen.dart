import 'package:expense_controller/controllers/add_expense_controller.dart';
import 'package:expense_controller/controllers/expense_list_controller.dart';
import 'package:expense_controller/controllers/settings_screen_controller.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:expense_controller/utils/utils.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:expense_controller/widgets/venm_settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ExpenseScreenController _expenseController = Get.find();
  AddExpenseScreenController _addExpenseController = Get.find();
  SettingsScreenController _settingsScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: appBarTitleWidget('Settings')),
        body: Container(
          child: ListView(children: [
            settingsRowWidget('Add category', "Adds new expense category", () {
              showAddCategoryDialog(_settingsScreenController);
            }),
            settingsRowWidget('Show notification for monthly expense limit',
                'Shows notification when current months\' total expense exceeds the monthly limit',
                () {
              showMonthlyExpenseLimitDialog(_settingsScreenController);
            }),
          ]),
        ),
      ),
    );
  }

  showAddCategoryDialog(SettingsScreenController settingsScreenController) {
    Get.defaultDialog(
        title: '',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: settingsScreenController.categoryNameController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Category Name',
                  hintMaxLines: 1,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4.0))),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () {
                if (settingsScreenController
                    .categoryNameController.text.isNotEmpty) {
                  var expenseCategory = ExpenseCategory(
                      settingsScreenController.categoryNameController.text,
                      id: _addExpenseController.expenseCategories.length);
                  settingsScreenController.addExpenseCategory(expenseCategory);
                  _addExpenseController.expenseCategories.add(expenseCategory);
                  Get.back();
                } else {
                  Utils.showSnackBar("Enter category name");
                }
              },
              child: Text(
                'ADD CATEGORY',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              color: Colors.redAccent,
            )
          ],
        ),
        radius: 10.0);
  }

  showMonthlyExpenseLimitDialog(
      SettingsScreenController settingsScreenController) {
    Get.defaultDialog(
        title: '',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller:
                  settingsScreenController.monthlyExpenseLimitController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Monthly Amount Limit',
                  hintMaxLines: 1,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4.0))),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () async {
                if (settingsScreenController
                    .monthlyExpenseLimitController.text.isNotEmpty) {
                  _settingsScreenController.setMonthlyLimit();
                  Get.back();
                } else {
                  Utils.showSnackBar('Enter monthly limit');
                }
              },
              child: Text(
                'SET LIMIT',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              color: Colors.redAccent,
            )
          ],
        ),
        radius: 10.0);
  }
}
