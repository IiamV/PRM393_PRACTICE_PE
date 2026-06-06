import 'package:flutter/foundation.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/recommend_products.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this.getProducts,
    this.recommendProducts = const RecommendProducts(),
  });

  final GetProducts getProducts;
  final RecommendProducts recommendProducts;

  List<Product> _products = [];
  final Set<int> _favoriteIds = <int>{};
  final Map<int, CartItem> _cartItems = <int, CartItem>{};
  bool _isLoading = false;
  String _query = '';
  String _category = 'All';
  ProductRecommendation? _recommendation;

  List<Product> get products => List.unmodifiable(_products);
  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);
  Map<int, CartItem> get cartItems => Map.unmodifiable(_cartItems);
  bool get isLoading => _isLoading;
  String get query => _query;
  String get category => _category;
  ProductRecommendation? get recommendation => _recommendation;

  List<String> get categories {
    final values = _products
        .map((p) => _titleCase(p.category))
        .toSet()
        .take(5)
        .toList();
    return ['All', ...values];
  }

  List<Product> get visibleProducts {
    return _products
        .where((product) {
          final matchesQuery =
              _query.isEmpty ||
              product.title.toLowerCase().contains(_query.toLowerCase()) ||
              product.description.toLowerCase().contains(_query.toLowerCase());
          final matchesCategory =
              _category == 'All' ||
              product.category.toLowerCase() == _category.toLowerCase();
          return matchesQuery && matchesCategory;
        })
        .toList(growable: false);
  }

  List<Product> get favoriteProducts {
    return _products
        .where((product) => _favoriteIds.contains(product.id))
        .toList(growable: false);
  }

  double get cartTotal =>
      _cartItems.values.fold(0, (sum, item) => sum + item.total);
  int get cartCount =>
      _cartItems.values.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadProducts() async {
    if (_isLoading || _products.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();
    _products = await getProducts();
    _isLoading = false;
    _refreshRecommendation();
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    _refreshRecommendation();
    notifyListeners();
  }

  void addToCart(Product product) {
    final existing = _cartItems[product.id];
    _cartItems[product.id] = existing == null
        ? CartItem(product: product, quantity: 1)
        : existing.copyWith(quantity: existing.quantity + 1);
    _refreshRecommendation();
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    _refreshRecommendation();
    notifyListeners();
  }

  void increment(int productId) {
    final item = _cartItems[productId];
    if (item == null) return;
    _cartItems[productId] = item.copyWith(quantity: item.quantity + 1);
    notifyListeners();
  }

  void decrement(int productId) {
    final item = _cartItems[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      _cartItems.remove(productId);
    } else {
      _cartItems[productId] = item.copyWith(quantity: item.quantity - 1);
    }
    _refreshRecommendation();
    notifyListeners();
  }

  void _refreshRecommendation() {
    _recommendation = recommendProducts(
      products: _products,
      favoriteIds: _favoriteIds,
      cartItems: _cartItems,
    );
  }

  String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
