class Expense {
  final int id;
  final int categoryId;
  final String description;
  final String createdAt;
  final double amount;
  String categoryName;
  static final columns = [
    "id",
    "category_id",
    "description",
    "created_at",
    "amount"
  ];

  Expense(this.categoryId, this.description, this.createdAt, this.amount,
      {this.id, this.categoryName});

  factory Expense.fromMap(Map<String, dynamic> data) {
    return Expense(data['category_id'], data['description'], data['created_at'],
        data['amount'],
        id: data['id']);
  }

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "description": description,
        "created_at": createdAt,
        "amount": amount
      };
}
