import 'package:ecommerce_ui/domain/entities/product.dart';
import 'package:ecommerce_ui/domain/repositories/product_repository.dart';
import 'package:ecommerce_ui/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class FakeProductRepository implements ProductRepository {
  const FakeProductRepository();

  @override
  Future<List<Product>> getProducts() async => const [
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
  ];
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('integration test adds product to cart and updates quantity', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp(repository: FakeProductRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Cart').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('CART').last);
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Pro Sound Headphones'), findsOneWidget);
    expect(find.text('\$299.00'), findsWidgets);

    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('cart-qty-1')), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
