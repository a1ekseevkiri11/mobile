import 'package:flutter/material.dart';
import 'package:front_product_directory/models/product_model.dart';
import 'package:front_product_directory/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.productId}') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool('favorite_${widget.productId}', isFavorite);
    });
  }

  Future<ProductModel> _fetchProductDetails() {
    return ProductService.getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукт'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<ProductModel>(
        future: _fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Product not found'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                    ),
                  ),
                const SizedBox(height: 16.0),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Категория: ${product.category.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Калории: ${product.calories} kcal',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                if (product.ingredients.isNotEmpty)
                  Text(
                    'Ингредиенты: ${product.ingredients}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 16.0),
                if (product.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                const SizedBox(height: 8.0),
                if (product.stock != null)
                  Text(
                    'Stock: ${product.stock}',
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
