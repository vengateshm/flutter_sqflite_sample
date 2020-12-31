import 'package:expense_controller/repository/expense_repository.dart';
import 'package:expense_controller/screens/expense_list_screen.dart';
import 'package:expense_controller/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final ExpenseRepository repository;

  HomeScreen(this.flutterLocalNotificationsPlugin, this.repository);

  @override
  _HomeScreenState createState() => _HomeScreenState(repository);
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseRepository repository;
  int _selectedIndex = 0;

  _HomeScreenState(this.repository);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Colors.green[500],
        ),
      ),
      body: getWidgetByPosition(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Expenses'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  getWidgetByPosition() {
    if (_selectedIndex == 0) {
      return ExpenseList(widget.flutterLocalNotificationsPlugin,repository);
    } else {
      return SettingsScreen(repository);
    }
  }
}
