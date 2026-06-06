import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/product_image.dart';
import 'favorites_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF121022),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final items = state.cartItems.values.toList(growable: false);
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 72,
                      color: Color(0xFF7166FF),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add products from Home to see quantities and totals here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            key: const ValueKey('cart-list'),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              for (final item in items)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF19172B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2111D4).withValues(alpha: 0.16),
                    ),
                  ),
                  child: Row(
                    children: [
                      ProductImage(
                        url: item.product.thumbnail,
                        width: 92,
                        height: 92,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      state.removeFromCart(item.product.id),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xFFA6A3B8),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.product.category,
                              style: const TextStyle(
                                color: Color(0xFFA6A3B8),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '\$${item.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF7166FF),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                _QtyButton(
                                  icon: Icons.remove_rounded,
                                  onTap: () => state.decrement(item.product.id),
                                ),
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    '${item.quantity}',
                                    key: ValueKey(
                                      'cart-qty-${item.product.id}',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                _QtyButton(
                                  icon: Icons.add_rounded,
                                  filled: true,
                                  onTap: () => state.increment(item.product.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF19172B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2111D4).withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SummaryRow(
                      label: 'Subtotal',
                      value: '\$${state.cartTotal.toStringAsFixed(2)}',
                    ),
                    const _SummaryRow(
                      label: 'Shipping',
                      value: 'Free',
                      valueColor: Colors.greenAccent,
                    ),
                    const _SummaryRow(label: 'Tax', value: '\$0.00'),
                    Divider(
                      color: Colors.white.withValues(alpha: 0.08),
                      height: 28,
                    ),
                    _SummaryRow(
                      label: 'Total',
                      value: '\$${state.cartTotal.toStringAsFixed(2)}',
                      large: true,
                      valueColor: const Color(0xFF7166FF),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Checkout'),
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
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 2,
        onHome: () => Navigator.of(context).popUntil((route) => route.isFirst),
        onFavorites: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FavoritesScreen())),
        onCart: () {},
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF2111D4) : const Color(0xFF242139),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : const Color(0xFF7166FF),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.large = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: large ? Colors.white : const Color(0xFFA6A3B8),
                fontSize: large ? 18 : 14,
                fontWeight: large ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: large ? 24 : 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
