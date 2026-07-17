class CategoryModel {
  final int id;

  final String name;

  CategoryModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(id: json['id'], name: json['name']);
}
