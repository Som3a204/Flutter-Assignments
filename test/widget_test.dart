import 'package:e_commerce/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen renders when there is no cached session',
          (WidgetTester tester) async {
        // A fresh AuthNotifier is logged out, so the router redirects to /login.
        await tester.pumpWidget(MyApp(router: createRouter(AuthNotifier())));
        await tester.pumpAndSettle();

        expect(find.text('Sign In'), findsOneWidget);
        expect(find.text('Welcome to E-Comm'), findsOneWidget);
      });
}
