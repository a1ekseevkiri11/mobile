import 'package:flutter/material.dart';
import 'package:front_product_directory/models/category_model.dart';
import 'package:front_product_directory/models/product_model.dart';
import 'package:front_product_directory/screens/product_details_screen.dart';
import 'package:front_product_directory/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<CategoryModel>> _categories;
  Future<List<ProductModel>>? _products;
  int? _selectedCategoryId;
  bool _showFavoritesOnly = false;

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

  Future<List<ProductModel>> _getFavoriteProducts(List<ProductModel> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ProductModel> favoriteProducts = [];

    for (var product in products) {
      bool isFavorite = prefs.getBool('favorite_${product.id}') ?? false;
      if (isFavorite) {
        favoriteProducts.add(product);
      }
    }

    return favoriteProducts;
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

              final allCategories = [
                CategoryModel(id: 0, name: 'без фильтров'),
                CategoryModel(id: -1, name: 'Избранное')
              ]
                ..addAll(snapshot.data!);

              return DropdownButton<int>(
                hint: const Text('без фильтров'),
                value: _selectedCategoryId == null ? null : _selectedCategoryId,
                onChanged: (value) {
                  setState(() {
                    if (value == -1) {
                      _showFavoritesOnly = true; 
                      _selectedCategoryId = -1;
                    } else if (value == 0) {
                      _showFavoritesOnly = false; 
                      _selectedCategoryId = null; 
                    } else {
                      _showFavoritesOnly = false;
                      _onCategorySelected(value);
                    }
                  });
                },
                items: allCategories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
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

                final products = snapshot.data!;
                if (_showFavoritesOnly) {
                  return FutureBuilder<List<ProductModel>>(
                    future: _getFavoriteProducts(products),
                    builder: (context, favSnapshot) {
                      if (favSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (favSnapshot.hasError) {
                        return Center(child: Text('Error: ${favSnapshot.error}'));
                      } else if (!favSnapshot.hasData || favSnapshot.data!.isEmpty) {
                        return const Center(child: Text('No favorite products found'));
                      }

                      final favoriteProducts = favSnapshot.data!;
                      return ListView.builder(
                        itemCount: favoriteProducts.length,
                        itemBuilder: (context, index) {
                          final product = favoriteProducts[index];
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
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
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
