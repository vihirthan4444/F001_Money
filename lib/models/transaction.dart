class Transaction {
  final String id;
  final String ledgerId;
  final double amount;
  final String type; // 'expense', 'income', 'transfer'
  final String categoryId;
  final String date;
  final String note;
  final String accountId;
  final String? toAccountId;
  final String userId;
  final double? initialAmount;
  final String? createdAt;
  final String? updatedAt;
  final String? updatedBy;

  Transaction({
    required this.id,
    required this.ledgerId,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note = '',
    required this.accountId,
    this.toAccountId,
    required this.userId,
    this.initialAmount,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      ledgerId: json['ledgerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      categoryId: json['categoryId'] as String,
      date: json['date'] as String,
      note: json['note'] as String? ?? '',
      accountId: json['accountId'] as String,
      toAccountId: json['toAccountId'] as String?,
      userId: json['userId'] as String,
      initialAmount: (json['initialAmount'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ledgerId': ledgerId,
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'date': date,
      'note': note,
      'accountId': accountId,
      if (toAccountId != null) 'toAccountId': toAccountId,
      'userId': userId,
      if (initialAmount != null) 'initialAmount': initialAmount,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
    };
  }

  Transaction copyWith({
    String? id,
    String? ledgerId,
    double? amount,
    String? type,
    String? categoryId,
    String? date,
    String? note,
    String? accountId,
    String? toAccountId,
    String? userId,
    double? initialAmount,
    String? createdAt,
    String? updatedAt,
    String? updatedBy,
  }) {
    return Transaction(
      id: id ?? this.id,
      ledgerId: ledgerId ?? this.ledgerId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      userId: userId ?? this.userId,
      initialAmount: initialAmount ?? this.initialAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
