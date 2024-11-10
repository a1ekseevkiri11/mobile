import 'package:flutter/material.dart';
import 'package:front_product_directory/models/category_model.dart';
import 'package:front_product_directory/models/product_model.dart';
import 'package:front_product_directory/screens/product_details_screen.dart';
import 'package:front_product_directory/services/product_service.dart';


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<CategoryModel>> _categories;
  Future<List<ProductModel>>? _products;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _categories = ProductService.getCategories();
    _products = ProductService.getProducts();
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      if (categoryId != null) {
        _products = ProductService.getProductsByCategory(categoryId);
      } else {
        _products = ProductService.getProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукты'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<CategoryModel>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No categories found');
              }

              final allCategories = [CategoryModel(id: 0, name: 'без фильтров')]
                  // ignore: prefer_spread_collections
                  ..addAll(snapshot.data!);

              return DropdownButton<int>(
                hint: const Text('Select a category'),
                value: _selectedCategoryId,
                onChanged: (value) {
                  _onCategorySelected(value == 0 ? null : value);
                },
                items: allCategories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id == 0 ? null : category.id,
                    child: Text(category.name),
                  );
                }).toList(),
              );
            },
          ),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found for this category'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(productId: product.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}