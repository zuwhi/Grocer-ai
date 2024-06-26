import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cart_scanner/pages/register/screen/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register Page UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterPage(),
    ));

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Alamat'), findsOneWidget);
    expect(find.text('Telepon'), findsOneWidget);
    // expect(find.text('Register'), findsOneWidget);

    // // Enter text to TextFields
    // await tester.enterText(find.byKey(const Key('Nama')), 'John Doe');
    // await tester.enterText(
    //     find.byKey(const Key('Email')), 'john.doe@example.com');
    // await tester.enterText(find.byKey(const Key('Password')), 'password123');
    // await tester.enterText(find.byKey(const Key('Alamat')), '123 Main St');
    // await tester.enterText(find.byKey(const Key('Telepon')), '1234567890');

    // // Tap register button and verify Snackbar message
    // await tester.tap(find.text('Register'));
    // await tester.pumpAndSettle();
    // expect(find.text('berhasil Membuat Akun silahkan login'), findsOneWidget);
  });
}
