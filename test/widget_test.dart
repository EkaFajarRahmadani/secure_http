import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/screens/login_screen.dart';
import 'package:secure_http/services/secure_storage_service.dart';

class _FakeSecureStorageService extends SecureStorageService {
  @override
  Future<bool> hasToken() async => false;
}

void main() {
  testWidgets('login form requires email and password', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(storageService: _FakeSecureStorageService()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login / Daftar'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });
}
