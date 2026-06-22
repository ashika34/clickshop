import 'package:click_shop/Feature/Splashscreen/viewmodel/splash_view_model.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/core/api_service.dart';
import 'package:click_shop/core/storage.dart';
import 'package:click_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const screenSizes = <String, Size>{
    'mobile': Size(360, 640),
    'tablet': Size(800, 1280),
    'desktop': Size(1440, 900),
  };

  for (final screen in screenSizes.entries) {
    testWidgets('main flow is responsive on ${screen.key}', (tester) async {
      await tester.binding.setSurfaceSize(screen.value);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      appRouter.go(AppRoutes.splash);

      await tester.pumpWidget(const ProviderScope(child: ClickShopApp()));

      expect(find.bySemanticsLabel('Click Shop logo'), findsOneWidget);

      await tester.pump(splashAnimationDuration);
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'ashikaspraveen@gmail.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password',
      );
      final loginButton = find.widgetWithText(FilledButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Hi, Welcome Ashikaspraveen'), findsOneWidget);
      expect(find.text('Categories'), findsNWidgets(2));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Ashikaspraveen'), findsOneWidget);
      expect(find.text('ashikaspraveen@gmail.com'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  const routeTestSizes = <String, Size>{
    'compact mobile': Size(320, 568),
    'landscape mobile': Size(667, 375),
    'tablet': Size(1024, 1366),
    'desktop': Size(1440, 900),
  };

  for (final screen in routeTestSizes.entries) {
    testWidgets('all routes are responsive on ${screen.key}', (tester) async {
      await tester.binding.setSurfaceSize(screen.value);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      appRouter.go(AppRoutes.home);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(_FakeApiService()),
            localStorageProvider.overrideWithValue(_TestStorage()),
          ],
          child: const ClickShopApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hi, Welcome Shopper'), findsOneWidget);
      expect(tester.takeException(), isNull);

      appRouter.go(AppRoutes.cart);
      await tester.pumpAndSettle();
      expect(find.text('My Cart'), findsOneWidget);
      expect(find.text('Responsive Test Product'), findsOneWidget);
      expect(tester.takeException(), isNull);

      appRouter.go(AppRoutes.productDetailPath(1));
      await tester.pumpAndSettle();
      expect(find.text('Responsive Test Product'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(tester.takeException(), isNull);

      appRouter.go(AppRoutes.checkout);
      await tester.pump(const Duration(milliseconds: 450));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Checkout'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

class _FakeApiService extends ApiService {
  @override
  Future<dynamic> get(String endpoint) async {
    if (endpoint == '/products/categories') {
      return const [
        {'slug': 'beauty', 'name': 'Beauty', 'url': ''},
        {'slug': 'furniture', 'name': 'Furniture', 'url': ''},
      ];
    }
    if (endpoint == '/products') {
      return {
        'products': [_productJson],
        'total': 1,
        'skip': 0,
        'limit': 1,
      };
    }
    return _productJson;
  }
}

class _TestStorage extends LocalStorage {
  _TestStorage() : super.inMemory();

  @override
  List<Map<String, dynamic>> readCart() => [
    {
      'id': 1,
      'name': 'Responsive Test Product',
      'brand': 'Click Shop',
      'price': 49.99,
      'image': '',
      'quantity': 3,
    },
  ];
}

const _productJson = <String, dynamic>{
  'id': 1,
  'title': 'Responsive Test Product',
  'description':
      'A product description used to verify flexible layouts on every screen.',
  'category': 'beauty',
  'price': 49.99,
  'discountPercentage': 10,
  'rating': 4.5,
  'stock': 12,
  'tags': ['responsive', 'test'],
  'brand': 'Click Shop',
  'sku': 'TEST-1',
  'weight': 1.2,
  'dimensions': {'width': 10, 'height': 20, 'depth': 5},
  'warrantyInformation': '1 year warranty',
  'shippingInformation': 'Ships in 2 days',
  'availabilityStatus': 'In Stock',
  'reviews': [
    {
      'rating': 5,
      'comment': 'Excellent',
      'reviewerName': 'Tester',
      'reviewerEmail': 'tester@example.com',
    },
  ],
  'returnPolicy': '30 day returns',
  'minimumOrderQuantity': 1,
  'meta': {'barcode': '123456'},
  'images': <String>[],
  'thumbnail': '',
};
