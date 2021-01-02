import 'package:expense_controller/controllers/expense_list_controller.dart';
import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/utils/constants.dart';
import 'package:expense_controller/utils/utils.dart';
import 'package:expense_controller/views/expense_add_screen.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseScreenController _expenseController =
      Get.find<ExpenseScreenController>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ExpenseListScreen(this.flutterLocalNotificationsPlugin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitleWidget('Expenses'),
      ),
      body: Obx(() => expenseListWidget(_expenseController.expenses)),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          var result = await Get.to(ExpenseAddScreen());
          if (result != null && result is Expense) {
            var showNotification = await isMonthlyExpenseLimitExceeded(
                _expenseController.expenses);
            if (showNotification) {
              Utils.showLocalAppNotification(
                  flutterLocalNotificationsPlugin,
                  "Alert!",
                  "Hello, You have exceeded the monthly expense limit. Spend wisely!",
                  payload: '');
            }
            var expense = Expense(result.categoryId, result.description,
                result.createdAt, result.amount,
                id: _expenseController.expenses.length,
                categoryName: result.categoryName);
            _expenseController.addExpense(expense);
          }
        },
      ),
    );
  }

  Widget expenseListWidget(List<Expense> expenses) {
    if (expenses == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (expenses.isEmpty) {
        return Center(
          child: Text('No Expense records found.'),
        );
      }
      return Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.green, Colors.lightGreen])),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Current Month Expenses',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Rs. ${getCurrentMonthTotalExpenses(_expenseController.expenses).toString()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenseController.expenses.length,
              itemBuilder: (BuildContext context, int index) {
                Expense expense = _expenseController.expenses[index];
                return ListTile(
                  onTap: () => {onExpenseItemTapped(expense)},
                  trailing: GestureDetector(
                    onTap: () {
                      _expenseController.deleteExpense(expense);
                    },
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                      size: 28.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryLabelWidget(expense),
                      Text(
                        expense.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Rs. ${expense.amount}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        getCreatedAt(expense.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      );
    }
  }

  double getCurrentMonthTotalExpenses(List<Expense> expenses) {
    var currentMonth = DateTime.now().month;
    var totalSum = 0.0;
    expenses.forEach((expense) {
      if (expense.createdAt.toMonth() == currentMonth)
        totalSum += expense.amount;
    });
    return totalSum;
  }

  Widget categoryLabelWidget(Expense expense) {
    if (expense.categoryName != null && expense.categoryName.isNotEmpty) {
      return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(
          expense.categoryName,
          style: TextStyle(fontSize: 12.0, color: Colors.red),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 0.0,
      );
    }
  }

  getCreatedAt(String createdAt) => Utils.formatDate(createdAt, "dd, MMM yyyy");

  onExpenseItemTapped(Expense expense) {
    Get.defaultDialog(
        title: 'Hello!',
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'You have spent Rs.${expense.amount}\non ${getCreatedAt(expense.createdAt)} for ${expense.categoryName}',
            textAlign: TextAlign.center,
            maxLines: 5,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ))
        ],
        radius: 10.0);
  }

  Future<bool> isMonthlyExpenseLimitExceeded(List<Expense> expenses) async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    SharedPreferences sharedPrefs = await prefs;
    var monthlyExpenseLimit = sharedPrefs.getDouble(MONTHLY_EXPENSE_LIMIT_KEY);
    if (monthlyExpenseLimit == null) return false;
    var currentMonthTotalExpenses = getCurrentMonthTotalExpenses(expenses);
    return currentMonthTotalExpenses > monthlyExpenseLimit;
  }
}
