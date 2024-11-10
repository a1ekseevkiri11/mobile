import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:front_product_directory/screens/product_list_screen.dart';


const String baseUrl = 'http://10.0.2.2:8000';


Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox<int>('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductsScreen(),
    );
  }
}

