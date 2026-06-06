import 'dart:convert';
import 'dart:io';

import '../models/product_model.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({HttpClient? client})
    : _client = client ?? HttpClient();

  final HttpClient _client;
  static final Uri _uri = Uri.parse('https://dummyjson.com/products');

  Future<List<ProductModel>> fetchProducts() async {
    final request = await _client
        .getUrl(_uri)
        .timeout(const Duration(seconds: 5));
    final response = await request.close().timeout(const Duration(seconds: 5));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Products API returned ${response.statusCode}');
    }
    final body = await response.transform(utf8.decoder).join();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final products = json['products'] as List<dynamic>;
    return products
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
