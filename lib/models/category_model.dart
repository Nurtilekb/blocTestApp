class CategoryModel {
  final String id; // Исправлено: int → String для согласованности с Notes
  final String name;

  CategoryModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(
        id: json['id']?.toString() ?? '', // Безопасное преобразование
        name: json['name'] ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
