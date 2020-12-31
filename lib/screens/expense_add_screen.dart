import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:expense_controller/repository/expense_repository.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:flutter/material.dart';

class ExpenseAddScreen extends StatefulWidget {
  final ExpenseRepository repository;

  ExpenseAddScreen(this.repository);

  @override
  _ExpenseAddScreenState createState() => _ExpenseAddScreenState(repository);
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  final ExpenseRepository repository;
  List<ExpenseCategory> expenseCategories = List();
  ExpenseCategory _selectedExpenseCategory;
  DateTime _selectedDateTime;

  _ExpenseAddScreenState(this.repository);

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  Future getAllExpenseCategories() async {
    List<ExpenseCategory> categories =
        await repository.getAllExpenseCategories();
    setState(() {
      expenseCategories.clear();
      expenseCategories.addAll(categories);
    });
  }

  @override
  void initState() {
    super.initState();
    getAllExpenseCategories();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: appBarTitleWidget('Add Expense'),
            ),
            body: expenseAddWidget()));
  }

  Widget expenseAddWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<ExpenseCategory>(
              isExpanded: true,
              value: _selectedExpenseCategory,
              hint: Text('Expense Category'),
              items: expenseCategories
                  .map((expenseCategory) => DropdownMenuItem<ExpenseCategory>(
                        child: Text(expenseCategory.name),
                        value: expenseCategory,
                      ))
                  .toList(),
              onChanged: (category) {
                setState(() {
                  _selectedExpenseCategory = category;
                });
              }),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _descriptionController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => onDateSelectClicked(),
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getDateText()),
                  Icon(
                    Icons.date_range,
                    color: Colors.deepOrange,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () => addExpense(),
            color: Colors.deepOrange,
            textColor: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Text(
              'ADD EXPENSE',
              style: TextStyle(fontSize: 14.0),
            ),
          )
        ],
      ),
    );
  }

  addExpense() async {
    String description = _descriptionController.text;
    String amount = _amountController.text;
    if (_selectedExpenseCategory == null) {
      return;
    }
    if (description.isEmpty) {
      return;
    }
    if (amount.isEmpty) {
      return;
    }
    if (_selectedDateTime == null) {
      return;
    }
    Navigator.pop(
        context,
        Expense(_selectedExpenseCategory.id, description,
            getCreatedAt(_selectedDateTime), double.parse(amount)));
    // repository.addExpense(_selectedExpenseCategory.id, description,
    //     getCreatedAt(_selectedDateTime), double.parse(amount));
  }

  onDateSelectClicked() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (dateTime != null) {
      setState(() {
        _selectedDateTime = dateTime;
      });
    }
  }

  String getDateText() {
    if (_selectedDateTime != null) {
      return "${_selectedDateTime.year}-${_selectedDateTime.month}-${_selectedDateTime.day}";
    } else {
      return "Select Date";
    }
  }

  String getCreatedAt(DateTime dateTime) =>
      "${dateTime.year}-${dateTime.month}-${dateTime.day}";
}
