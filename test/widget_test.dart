import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/main.dart';

void main() {
  testWidgets('login form requires email and password', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Login / Daftar'), findsOneWidget);
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });
}
