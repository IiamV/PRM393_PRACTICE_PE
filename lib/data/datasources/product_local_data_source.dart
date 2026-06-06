import '../models/product_model.dart';

class ProductLocalDataSource {
  const ProductLocalDataSource();

  List<ProductModel> fallbackProducts() => const [
    ProductModel(
      id: 1,
      title: 'Pro Sound Headphones',
      description:
          'Noise-canceling headphones with 40h battery life and studio clarity.',
      category: 'Audio',
      price: 299,
      rating: 4.9,
      thumbnail:
          'https://cdn.dummyjson.com/product-images/mobile-accessories/apple-airpods-max-silver/thumbnail.webp',
      images: [
        'https://cdn.dummyjson.com/product-images/mobile-accessories/apple-airpods-max-silver/1.webp',
      ],
      brand: 'SoundCore',
      stock: 18,
    ),
    ProductModel(
      id: 2,
      title: 'Minimalist Smartwatch',
      description:
          'Health tracking, OLED display, and lightweight aluminum body.',
      category: 'Watches',
      price: 159.5,
      rating: 4.7,
      thumbnail:
          'https://cdn.dummyjson.com/product-images/mobile-accessories/apple-watch-series-4-gold/thumbnail.webp',
      images: [
        'https://cdn.dummyjson.com/product-images/mobile-accessories/apple-watch-series-4-gold/1.webp',
      ],
      brand: 'Orbit',
      stock: 25,
    ),
    ProductModel(
      id: 3,
      title: 'Instant Retro Camera',
      description:
          'Vintage style camera with instant film and soft pastel finish.',
      category: 'Cameras',
      price: 89,
      rating: 4.8,
      thumbnail:
          'https://cdn.dummyjson.com/product-images/mobile-accessories/selfie-stick-monopod/thumbnail.webp',
      images: [
        'https://cdn.dummyjson.com/product-images/mobile-accessories/selfie-stick-monopod/1.webp',
      ],
      brand: 'RetroPix',
      stock: 12,
    ),
  ];
}
