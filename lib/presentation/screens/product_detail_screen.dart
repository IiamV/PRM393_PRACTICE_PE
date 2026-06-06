import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../state/app_scope.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/product_image.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: state,
          builder: (context, _) {
            final isFavorite = state.favoriteIds.contains(product.id);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 430,
                  backgroundColor: const Color(0xFF121022),
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const CircleAvatar(
                      backgroundColor: Color(0x77000000),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => state.toggleFavorite(product),
                      icon: CircleAvatar(
                        backgroundColor: const Color(0x77000000),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? Colors.redAccent : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        ProductImage(
                          url: product.images.isEmpty
                              ? product.thumbnail
                              : product.images.first,
                          borderRadius: BorderRadius.zero,
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xDD121022)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
                    decoration: const BoxDecoration(
                      color: Color(0xFF121022),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF7166FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2111D4,
                                ).withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'In Stock',
                                style: TextStyle(
                                  color: Color(0xFF8F86FF),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF5B83B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 18,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: Colors.white12,
                            ),
                            const Text(
                              '2.4k Reviews',
                              style: TextStyle(
                                color: Color(0xFFA6A3B8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: Color(0xFFC8C5D8),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Rating Distribution',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _RatingBar(
                          label: '5',
                          value: 0.85,
                          percent: '85%',
                        ),
                        const _RatingBar(
                          label: '4',
                          value: 0.10,
                          percent: '10%',
                        ),
                        const _RatingBar(
                          label: '3',
                          value: 0.03,
                          percent: '3%',
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            key: const ValueKey('detail-add-cart'),
                            onPressed: () => state.addToCart(product),
                            icon: const Icon(Icons.shopping_cart_rounded),
                            label: const Text('Add to Cart'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2111D4),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onHome: () => Navigator.of(context).popUntil((route) => route.isFirst),
        onFavorites: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FavoritesScreen())),
        onCart: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CartScreen())),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.label,
    required this.value,
    required this.percent,
  });

  final String label;
  final double value;
  final String percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFFA6A3B8)),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                color: const Color(0xFF2111D4),
                backgroundColor: const Color(0xFF211F35),
              ),
            ),
          ),
          SizedBox(
            width: 46,
            child: Text(
              percent,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color(0xFFA6A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}
