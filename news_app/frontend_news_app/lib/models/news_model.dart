import 'package:frontend_news_app/models/tags_model.dart';


class NewsModel {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String? imageUrl;
  final List<TagsModel> tags;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    required this.tags,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      imageUrl: json['image_url'],
      tags: (json['tags'] as List)
          .map((tagJson) => TagsModel.fromJson(tagJson))
          .toList(),
    );
  }
}