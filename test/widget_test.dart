
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/signup_screen.dart';

void main() {
  testWidgets('Splash screen navigates to SignUpScreen after 5 seconds', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the splash screen is displayed.
    expect(find.text('BOX BEE'), findsOneWidget);
    expect(find.byIcon(Icons.gavel_sharp), findsOneWidget);

    // Fast-forward time by 5 seconds to trigger the navigation.
    await tester.pump(const Duration(seconds: 5));

    // Pump again to settle the navigation and animations.
    await tester.pumpAndSettle();

    // Verify that we have navigated to the SignUpScreen.
    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
