import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onHome,
    required this.onFavorites,
    required this.onCart,
  });

  final int currentIndex;
  final VoidCallback onHome;
  final VoidCallback onFavorites;
  final VoidCallback onCart;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'HOME', onTap: onHome),
      _NavItem(
        icon: Icons.favorite_rounded,
        label: 'FAVORITE',
        onTap: onFavorites,
      ),
      _NavItem(icon: Icons.shopping_cart_rounded, label: 'CART', onTap: onCart),
    ];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xEE19172B),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < items.length; i++)
            _BottomNavButton(item: items[i], selected: i == currentIndex),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({required this.item, required this.selected});

  final _NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF2111D4) : const Color(0xFF8C8A9F);
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 86,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: color),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 5 : 0,
              height: selected ? 5 : 0,
              decoration: const BoxDecoration(
                color: Color(0xFF2111D4),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
