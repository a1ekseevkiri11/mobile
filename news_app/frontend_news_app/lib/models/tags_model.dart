class TagsModel {
  final int id;
  final String title;

  TagsModel({required this.id, required this.title});

  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
