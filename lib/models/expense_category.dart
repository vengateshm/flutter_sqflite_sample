class ExpenseCategory {
  int id;
  final String name;
  static final columns = ["id", "name"];

  ExpenseCategory(this.name, {this.id});

  factory ExpenseCategory.fromMap(Map<String, dynamic> data) {
    var expenseCategory = ExpenseCategory(data['name']);
    expenseCategory.id = data['id'];
    return expenseCategory;
  }

  Map<String, dynamic> toMap() => {"name": name};
}

List<ExpenseCategory> get defaultExpenseCategories {
  var expenseCategoriesList = List<ExpenseCategory>();
  expenseCategoriesList.add(ExpenseCategory("Food"));
  expenseCategoriesList.add(ExpenseCategory("Public Transport"));
  expenseCategoriesList.add(ExpenseCategory("Groceries"));
  expenseCategoriesList.add(ExpenseCategory("Vehicle Fuel"));
  expenseCategoriesList.add(ExpenseCategory("Miscellaneous"));
  return expenseCategoriesList;
}
