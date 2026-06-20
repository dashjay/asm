import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:asm/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AsmApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('家庭资产'), findsOneWidget);
  });
}
