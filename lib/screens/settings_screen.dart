import 'package:expense_controller/repository/expense_repository.dart';
import 'package:expense_controller/utils/constants.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:expense_controller/widgets/venm_settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final ExpenseRepository repository;

  SettingsScreen(this.repository);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(repository);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ExpenseRepository repository;
  TextEditingController _categoryNameController;
  TextEditingController _monthlyExpenseLimitController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _SettingsScreenState(this.repository);

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();
    _monthlyExpenseLimitController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _categoryNameController?.dispose();
    _monthlyExpenseLimitController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: appBarTitleWidget('Settings')),
        body: Container(
          child: ListView(children: [
            settingsRowWidget('Add category', "Adds new expense category", () {
              showAddCategoryDialog(_categoryNameController, repository);
            }),
            settingsRowWidget('Show notification for monthly expense limit',
                'Shows notification when current months\' total expense exceeds the monthly limit',
                () {
              showMonthlyExpenseLimitDialog(
                  _monthlyExpenseLimitController, _prefs);
            }),
          ]),
        ),
      ),
    );
  }

  showAddCategoryDialog(TextEditingController categoryNameController,
      ExpenseRepository repository) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: categoryNameController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintMaxLines: 1,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 4.0))),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (categoryNameController.text.isNotEmpty) {
                        repository
                            .addExpenseCategory(categoryNameController.text);
                        Navigator.of(context).pop();
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
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)));
        });
  }

  showMonthlyExpenseLimitDialog(
      TextEditingController monthlyExpenseLimitController,
      Future<SharedPreferences> prefs) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: monthlyExpenseLimitController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Monthly Amount Limit',
                        hintMaxLines: 1,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 4.0))),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (monthlyExpenseLimitController.text.isNotEmpty) {
                        var sharedPrefs = await prefs;
                        sharedPrefs.setDouble(MONTHLY_EXPENSE_LIMIT_KEY,
                            double.parse(monthlyExpenseLimitController.text));
                        Navigator.of(context).pop();
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
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)));
        });
  }
}
