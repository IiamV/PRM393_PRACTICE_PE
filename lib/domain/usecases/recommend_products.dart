import '../entities/cart_item.dart';
import '../entities/product.dart';

class ProductRecommendation {
  const ProductRecommendation({required this.product, required this.reason});

  final Product product;
  final String reason;
}

class RecommendProducts {
  const RecommendProducts();

  ProductRecommendation? call({
    required List<Product> products,
    required Set<int> favoriteIds,
    required Map<int, CartItem> cartItems,
  }) {
    final seen = {...favoriteIds, ...cartItems.keys};
    final candidates = products
        .where((product) => !seen.contains(product.id))
        .toList();
    if (candidates.isEmpty) return null;

    final preferredCategories = <String, int>{};
    for (final id in seen) {
      final match = products.where((product) => product.id == id);
      if (match.isNotEmpty) {
        final category = match.first.category;
        preferredCategories[category] =
            (preferredCategories[category] ?? 0) + 1;
      }
    }

    candidates.sort((a, b) {
      final categoryScore = (preferredCategories[b.category] ?? 0).compareTo(
        preferredCategories[a.category] ?? 0,
      );
      if (categoryScore != 0) return categoryScore;
      final ratingScore = b.rating.compareTo(a.rating);
      if (ratingScore != 0) return ratingScore;
      return a.price.compareTo(b.price);
    });

    final product = candidates.first;
    final hasPreference = preferredCategories.containsKey(product.category);
    final reason = hasPreference
        ? 'AI picked this because you showed interest in ${product.category}.'
        : 'AI picked this from rating, price, and product popularity signals.';
    return ProductRecommendation(product: product, reason: reason);
  }
}
