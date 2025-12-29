enum AccountType { cash, debit, credit, loan_given, loan_taken }

class Account {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String userId;

  Account({
    required this.id,
    required this.name,
    required this.type,
    this.balance = 0.0,
    required this.userId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _parseAccountType(json['type'] as String),
      balance: (json['balance'] ?? 0.0).toDouble(),
      userId: json['userId'] as String,
    );
  }

  static AccountType _parseAccountType(String type) {
    switch (type) {
      case 'cash':
        return AccountType.cash;
      case 'debit':
        return AccountType.debit;
      case 'credit':
        return AccountType.credit;
      case 'loan_given':
        return AccountType.loan_given;
      case 'loan_taken':
        return AccountType.loan_taken;
      default:
        return AccountType.cash;
    }
  }

  static String accountTypeToString(AccountType type) {
    return type.toString().split('.').last;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': accountTypeToString(type),
      'balance': balance,
      'userId': userId,
    };
  }

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? userId,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      userId: userId ?? this.userId,
    );
  }
}
