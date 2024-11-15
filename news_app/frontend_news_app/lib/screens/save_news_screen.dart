import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OfflineNewsScreen extends StatelessWidget {
  const OfflineNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('offlineNews');
    final savedNews = box.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Сохранённые новости')),
      body: ListView.builder(
        itemCount: savedNews.length,
        itemBuilder: (context, index) {
          final news = savedNews[index];
          return ListTile(
            title: Text(news['title']),
            subtitle: Text(news['description']),
          );
        },
      ),
    );
  }
}