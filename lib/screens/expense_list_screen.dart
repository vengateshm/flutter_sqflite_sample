import 'package:expense_controller/models/expense.dart';
import 'package:expense_controller/repository/expense_repository.dart';
import 'package:expense_controller/screens/expense_add_screen.dart';
import 'package:expense_controller/utils/utils.dart';
import 'package:expense_controller/widgets/venm_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_controller/utils/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ExpenseList extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final ExpenseRepository repository;

  ExpenseList(this.flutterLocalNotificationsPlugin, this.repository);

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  List<Expense> expenses;

  @override
  void initState() {
    super.initState();
    getAllExpenses();
  }

  void getAllExpenses() {
    widget.repository.getAllExpenses().then((value) {
      setState(() {
        expenses = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _expenses = expenses;
    return Scaffold(
      appBar: AppBar(
        title: appBarTitleWidget('Expenses'),
      ),
      body: expenseListWidget(_expenses, widget.repository),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ExpenseAddScreen(widget.repository)));
          if (result != null) {
            var showNotification = await isMonthlyExpenseLimitExceeded();
            if (showNotification) {
              Utils.showLocalAppNotification(
                  widget.flutterLocalNotificationsPlugin,
                  "Alert!",
                  "Hello, You have exceeded the monthly expense limit. Spend wisely!",
                  payload: '');
            }
            widget.repository.addExpense(result.categoryId, result.description,
                result.createdAt, result.amount);
            getAllExpenses();
          }
        },
      ),
    );
  }

  Widget expenseListWidget(
      List<Expense> _expenses, ExpenseRepository repository) {
    if (_expenses == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (_expenses.isEmpty) {
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
                "Rs. ${getCurrentMonthTotalExpenses(_expenses).toString()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (BuildContext context, int index) {
                Expense item = _expenses[index];
                return ListTile(
                  onTap: () => {onExpenseItemTapped(item)},
                  trailing: GestureDetector(
                    onTap: () => deleteExpense(item, repository),
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
                      categoryLabelWidget(item),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Rs. ${item.amount}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        getCreatedAt(item.createdAt),
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

  deleteExpense(Expense expense, ExpenseRepository repository) {
    repository.deleteExpense(expense.id);
    getAllExpenses();
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
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hello!'),
            content: Text(
                'You have spent Rs.${expense.amount} on ${getCreatedAt(expense.createdAt)} for ${expense.categoryName}'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
            actionsPadding: EdgeInsets.all(10.0),
            elevation: 12.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          );
        });
  }

  Future<bool> isMonthlyExpenseLimitExceeded() async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    SharedPreferences sharedPrefs = await prefs;
    var monthlyExpenseLimit = sharedPrefs.getDouble(MONTHLY_EXPENSE_LIMIT_KEY);
    if (monthlyExpenseLimit == null) return false;
    var currentMonthTotalExpenses = getCurrentMonthTotalExpenses(expenses);
    return currentMonthTotalExpenses > monthlyExpenseLimit;
  }
}
