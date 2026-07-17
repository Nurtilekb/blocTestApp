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

  // Преобразование в Map (для Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.millisecondsSinceEpoch,
    };
  }

  // Создание из Map (из Firestore)
  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
    );
  }
}
