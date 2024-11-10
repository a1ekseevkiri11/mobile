import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:front_product_directory/models/category_model.dart';
import 'package:front_product_directory/models/product_model.dart';
import 'package:front_product_directory/constant.dart';


class ProductService {
  static Future<ProductModel> getProductById(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$productId/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }
  
  static Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/category/$categoryId/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/product/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}