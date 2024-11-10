import 'package:flutter/material.dart';
import 'package:front_product_directory/screens/product_list_screen.dart';


const String baseUrl = 'http://10.0.2.2:8000';


void main() {
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

