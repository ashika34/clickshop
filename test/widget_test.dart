import 'package:click_shop/Feature/Splashscreen/viewmodel/splash_view_model.dart';
import 'package:click_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navigates from splash to login and then home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ClickShopApp()));

    expect(find.bySemanticsLabel('Click Shop logo'), findsOneWidget);

    await tester.pump(splashAnimationDuration);
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'shopper@example.com',
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

    expect(find.text('Hello, Ashika 👋'), findsOneWidget);
    expect(find.text('Categories'), findsNWidgets(2));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
