import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:frontend_news_app/models/tags_model.dart';
import 'package:frontend_news_app/constant.dart';


class TagsService {

  static Future<List<TagsModel>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/tags/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => TagsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}