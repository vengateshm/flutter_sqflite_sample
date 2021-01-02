import 'package:expense_controller/controllers/add_expense_controller.dart';
import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/models/expense_category.dart';
import 'package:expense_controller/utils/utils.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ExpenseAddScreen extends StatelessWidget {
  final AddExpenseScreenController _addExpenseController =
      Get.find<AddExpenseScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitleWidget('Add Expense'),
        ),
        body: expenseAddWidget(context));
  }

  Widget expenseAddWidget(BuildContext parentContext) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => DropdownButton<ExpenseCategory>(
                isExpanded: true,
                value: _addExpenseController.selectedExpenseCategory.value,
                hint: Text('Expense Category'),
                items: _addExpenseController.expenseCategories
                    .map((expenseCategory) => DropdownMenuItem<ExpenseCategory>(
                          child: Text(expenseCategory.name),
                          value: expenseCategory,
                        ))
                    .toList(),
                onChanged: (category) {
                  _addExpenseController.setSelectedExpenseCategory(category);
                })),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _addExpenseController.descriptionController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _addExpenseController.amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => onDateSelectClicked(parentContext),
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => dateTextWidget(
                        _addExpenseController.selectedDate.value)),
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
      ),
    );
  }

  onDateSelectClicked(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (dateTime != null) {
      _addExpenseController.setSelectedDateTime(dateTime);
    }
  }

  addExpense() async {
    String description = _addExpenseController.descriptionController.text;
    String amount = _addExpenseController.amountController.text;
    if (_addExpenseController.selectedExpenseCategory.value == null) {
      Utils.showSnackBar('Select expense category');
      return;
    }
    if (description.isEmpty) {
      Utils.showSnackBar('Enter description');
      return;
    }
    if (amount.isEmpty) {
      Utils.showSnackBar('Enter amount');
      return;
    }
    if (_addExpenseController.selectedDate.value == "Select Date" ||
        _addExpenseController.selectedDate.value.isEmpty) {
      Utils.showSnackBar('Select Date');
      return;
    }
    Get.back(
        result: Expense(
            _addExpenseController.selectedExpenseCategory.value.id,
            description,
            _addExpenseController.selectedDate.value,
            double.parse(amount),
            categoryName:
                _addExpenseController.selectedExpenseCategory.value.name));
    _addExpenseController.resetAllFields();
  }

  Widget dateTextWidget(String selectedDate) {
    var formattedDate;
    if (selectedDate != "Select Date")
      formattedDate = Utils.formatDate(selectedDate, "dd, MMM yyyy");
    else
      formattedDate = selectedDate;
    return Text(formattedDate);
  }
}
