import 'package:click_shop/Feature/Splashscreen/viewmodel/splash_view_model.dart';
import 'package:click_shop/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the animated logo and navigates to home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ClickShopApp()));

    expect(find.bySemanticsLabel('Click Shop logo'), findsOneWidget);
    expect(find.text('Welcome to Click Shop'), findsNothing);

    await tester.pump(splashAnimationDuration);
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Click Shop'), findsOneWidget);
  });
}
