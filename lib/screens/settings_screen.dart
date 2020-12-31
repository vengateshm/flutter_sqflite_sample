import 'package:expense_controller/repository/expense_repository.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:expense_controller/widgets/venm_settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  final ExpenseRepository repository;

  SettingsScreen(this.repository);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(repository);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ExpenseRepository repository;
  TextEditingController _categoryNameController;

  _SettingsScreenState(this.repository);

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _categoryNameController?.dispose();
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
            settingsRowWidget(
                'Set alarm for expense category',
                'Triggers alarm when current month expense exceeds the monthly limit of the category',
                () => {}),
            settingsRowWidget(
                'Set monthly expense alarm',
                'Triggers alarm when current month expense exceeds the monthly limit',
                () => {}),
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
}
