import 'package:expense_controller/controllers/add_expense_controller.dart';
import 'package:expense_controller/controllers/expense_list_controller.dart';
import 'package:expense_controller/controllers/settings_screen_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseScreenController>(() => ExpenseScreenController());
    Get.lazyPut<AddExpenseScreenController>(() => AddExpenseScreenController());
    Get.lazyPut<SettingsScreenController>(() => SettingsScreenController());
  }
}
