import 'package:hive/hive.dart';

part 'user.g.dart'; // Это важно! Ссылка на сгенерированный файл

@HiveType(typeId: 0)
class Notes {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
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
    bool? isFavorite,
    String? imageUrl,
    List<String>? tags,
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
      date: DateTime.parse(json['date']),
    );
  }
}
