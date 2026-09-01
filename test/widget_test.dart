import 'package:bbo_shop_app/app/app.dart';
import 'package:bbo_shop_app/features/splash/presentation/controllers/startup_check_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows retry page when API is unavailable', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [startupCheckProvider.overrideWith((ref) async => false)],
        child: const AppView(),
      ),
    );

    await tester.pump();

    expect(find.text('Connexion indisponible'), findsOneWidget);
    expect(find.text('Actualiser'), findsOneWidget);
  });
}
