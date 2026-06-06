import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/product_image.dart';
import 'cart_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF121022),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final favorites = state.favoriteProducts;
          return Column(
            children: [
              const _Tabs(),
              Expanded(
                child: favorites.isEmpty
                    ? const _EmptyFavorites()
                    : ListView.separated(
                        key: const ValueKey('favorites-list'),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        itemCount: favorites.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final product = favorites[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF19172B),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: ProductImage(
                                    url: product.thumbnail,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.stock > 20
                                            ? 'BEST SELLER'
                                            : 'NEW ARRIVAL',
                                        style: const TextStyle(
                                          color: Color(0xFF7166FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '\$${product.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                Text(
                                                  product.category,
                                                  style: const TextStyle(
                                                    color: Color(0xFFA6A3B8),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () =>
                                                state.toggleFavorite(product),
                                            icon: const Icon(
                                              Icons.delete_outline_rounded,
                                              size: 18,
                                            ),
                                            label: const Text('Remove'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onHome: () => Navigator.of(context).popUntil((route) => route.isFirst),
        onFavorites: () {},
        onCart: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CartScreen())),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    const labels = ['All', 'Clothing', 'Accessories'];
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          for (final label in labels)
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: label == 'All'
                          ? const Color(0xFF2111D4)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: label == 'All'
                        ? const Color(0xFF7166FF)
                        : const Color(0xFFA6A3B8),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 72,
              color: Color(0xFF7166FF),
            ),
            SizedBox(height: 14),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              'Tap heart icons on products to build your shortlist.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA6A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}
