class Notes {
  final String id;

  String title;

  String description;

  DateTime date;

  String category;

  Notes({
    required this.title,
    required this.description,
    required this.category,
    required this.id,
    required this.date,
  });

  Notes copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
  }) {
    return Notes(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
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
    );
  }
}
