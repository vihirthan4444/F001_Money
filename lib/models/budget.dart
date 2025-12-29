class Budget {
  final String id;
  final String ledgerId;
  final String categoryId;
  final double amount;
  final String userId;

  Budget({
    required this.id,
    required this.ledgerId,
    required this.categoryId,
    required this.amount,
    required this.userId,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      ledgerId: json['ledgerId'] as String,
      categoryId: json['categoryId'] as String,
      amount: (json['amount'] as num).toDouble(),
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ledgerId': ledgerId,
      'categoryId': categoryId,
      'amount': amount,
      'userId': userId,
    };
  }

  Budget copyWith({
    String? id,
    String? ledgerId,
    String? categoryId,
    double? amount,
    String? userId,
  }) {
    return Budget(
      id: id ?? this.id,
      ledgerId: ledgerId ?? this.ledgerId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      userId: userId ?? this.userId,
    );
  }
}
