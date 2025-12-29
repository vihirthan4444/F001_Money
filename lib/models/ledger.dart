class Ledger {
  final String id;
  final String name;
  final String color;
  final String icon;
  final String userId;
  final List<String> sharedWith;

  Ledger({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.userId,
    this.sharedWith = const [],
  });

  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String? ?? 'bg-indigo-500',
      icon: json['icon'] as String? ?? 'Briefcase',
      userId: json['userId'] as String,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'userId': userId,
      'sharedWith': sharedWith,
    };
  }

  Ledger copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    String? userId,
    List<String>? sharedWith,
  }) {
    return Ledger(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      userId: userId ?? this.userId,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}
