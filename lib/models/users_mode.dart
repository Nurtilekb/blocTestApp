class Notes {
  final String id;
  final String;
  final String description;
  final DateTime date;
  final String category;
  final String categoryId;

  Notes({
    required this.title,
    required this.description,
    required this.category,
    required this.id,
    required this.date,
    required this.categoryId,
  });

  Notes copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    String? categoryId,
  }) {
    return Notes(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  // Преобразование в Map (для JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
    };
  }

  // Создание из Map (из JSON)
  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      date: DateTime.parse(json['date'] as String),
      categoryId: json['categoryId'],
    );
  }
}
