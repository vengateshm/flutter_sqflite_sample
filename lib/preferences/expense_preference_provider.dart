import 'package:expense_controller/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensePreferenceProvider {
  ExpensePreferenceProvider._();

  static final ExpensePreferenceProvider instance =
      ExpensePreferenceProvider._();
  static SharedPreferences _preferences;

  Future<SharedPreferences> get preferences async {
    if (_preferences != null) return _preferences;
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<void> setMonthlyLimit(double monthlyLimit) async {
    final prefs = await ExpensePreferenceProvider.instance.preferences;
    prefs.setDouble(MONTHLY_EXPENSE_LIMIT_KEY, monthlyLimit);
  }
}
