import 'package:ecommerce_ui/domain/entities/product.dart';
import 'package:ecommerce_ui/domain/repositories/product_repository.dart';
import 'package:ecommerce_ui/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductRepository implements ProductRepository {
  const FakeProductRepository();

  @override
  Future<List<Product>> getProducts() async => sampleProducts;
}

const sampleProducts = [
  Product(
    id: 1,
    title: 'Pro Sound Headphones',
    description: 'Noise-canceling, 40h battery life',
    category: 'Audio',
    price: 299,
    rating: 4.9,
    thumbnail: 'https://example.com/headphones.png',
    images: ['https://example.com/headphones.png'],
    stock: 10,
  ),
  Product(
    id: 2,
    title: 'Minimalist Smartwatch',
    description: 'Health tracking, OLED display',
    category: 'Watches',
    price: 159.5,
    rating: 4.7,
    thumbnail: 'https://example.com/watch.png',
    images: ['https://example.com/watch.png'],
    stock: 30,
  ),
];

void main() {
  testWidgets('widget test renders home product list', (tester) async {
    await tester.pumpWidget(const MyApp(repository: FakeProductRepository()));
    await tester.pumpAndSettle();

    expect(find.text('New Arrivals'), findsOneWidget);
    expect(find.text('Pro Sound Headphones'), findsOneWidget);
    expect(find.byKey(const ValueKey('ai-recommendation')), findsOneWidget);
  });

  testWidgets('navigation test opens product detail', (tester) async {
    await tester.pumpWidget(const MyApp(repository: FakeProductRepository()));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey('product-list')),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pro Sound Headphones').first);
    await tester.pumpAndSettle();

    expect(find.text('Description'), findsOneWidget);
    expect(find.byKey(const ValueKey('detail-add-cart')), findsOneWidget);
  });
}
