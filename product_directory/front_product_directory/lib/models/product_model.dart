import 'package:front_product_directory/models/category_model.dart';
import 'package:front_product_directory/constant.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final int calories;
  final String ingredients;
  final String imageUrl;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.ingredients,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      calories: json['calories'],
      ingredients: json['ingredients'],
      // ignore: prefer_interpolation_to_compose_strings
      imageUrl: baseUrl + json['image_url'],
      category: CategoryModel.fromJson(json['category']),
    );
  }

  get price => null;

  get categoryName => null;

  get rating => null;

  get stock => null;
}