import 'package:flutter/material.dart';
import 'package:frontend_news_app/constant.dart';
import 'package:frontend_news_app/models/news_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  NewsDetailScreen({required this.news});

  void _saveToHive(BuildContext context) async {
    final box = Hive.box('offlineNews');

    if (box.containsKey(news.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Новость уже сохранена')),
      );
      return;
    }

    await box.put(news.id, {
      'title': news.title,
      'description': news.description,
      'imageUrl': news.imageUrl,
      'date': news.date.toIso8601String(),
      'tags': news.tags.map((tag) => tag.title).toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Новость сохранена для оффлайн просмотра')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.save),
            label: Text('Сохранить'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _saveToHive(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.network(
                    baseUrl + news.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              Text(
                news.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                news.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Published on: ${DateFormat('yyyy-MM-dd').format(news.date)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              if (news.tags.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: news.tags.map((tag) {
                        return Chip(
                          label: Text(tag.title),
                        );
                      }).toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
