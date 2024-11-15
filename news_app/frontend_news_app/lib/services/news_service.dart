import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:frontend_news_app/models/news_model.dart';
import 'package:frontend_news_app/constant.dart';


class NewsService {
  static Future<NewsModel> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/news/$id/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return NewsModel.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<List<NewsModel>> getWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    bool orderDesc = true,
    int page = 1,
    int pageSize = 25,
  }) async {
    Map<String, String> queryParams = {
      'order_desc': orderDesc.toString(),
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    if (tags != null && tags.isNotEmpty) {
      queryParams['tags'] = tags.join(',');
    }

    final Uri uri = Uri.parse('$baseUrl/news/').replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      return data.map((json) => NewsModel.fromJson(json)).toList();
    } else if(response.statusCode == 404){
      return [];
    }else {
      throw Exception('Failed to load news');
    }
  }
}