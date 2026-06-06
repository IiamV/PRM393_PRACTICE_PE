import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: state,
          builder: (context, _) {
            return Column(
              children: [
                _Header(cartCount: state.cartCount),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const ValueKey('search-field'),
                          onChanged: state.setQuery,
                          decoration: InputDecoration(
                            hintText: 'Search tech & lifestyle...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: const Color(0xFF211F35),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFF2111D4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.tune_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      final selected = category == state.category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) => state.setCategory(category),
                        selectedColor: const Color(0xFF2111D4),
                        backgroundColor: const Color(0xFF211F35),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFFC8C5D8),
                          fontWeight: FontWeight.w700,
                        ),
                        shape: const StadiumBorder(
                          side: BorderSide(color: Colors.transparent),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          key: const ValueKey('product-list'),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          itemCount:
                              state.visibleProducts.length +
                              (state.recommendation == null ? 0 : 1),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            if (index == 0 && state.recommendation != null) {
                              final recommendation = state.recommendation!;
                              return _AiRecommendation(
                                title: recommendation.product.title,
                                reason: recommendation.reason,
                              );
                            }
                            final productIndex =
                                index - (state.recommendation == null ? 0 : 1);
                            final product = state.visibleProducts[productIndex];
                            return ProductCard(
                              product: product,
                              onOpen: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onHome: () {},
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

class _Header extends StatelessWidget {
  const _Header({required this.cartCount});

  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF211F35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu_rounded, color: Color(0xFFC8C5D8)),
          ),
          const Expanded(
            child: Text(
              'New Arrivals',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF211F35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFFC8C5D8),
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  top: -4,
                  right: -3,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2111D4),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiRecommendation extends StatelessWidget {
  const _AiRecommendation({required this.title, required this.reason});

  final String title;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('ai-recommendation'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2111D4).withValues(alpha: 0.15),
        border: Border.all(
          color: const Color(0xFF7166FF).withValues(alpha: 0.45),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFF8F86FF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI pick: $title',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    color: Color(0xFFC8C5D8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
