import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('MyApp renders home screen smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    // Verify that the portfolio home screen renders expected content.
    expect(find.text('My Portofolio'), findsWidgets);
    expect(find.text('Add Education Record'), findsOneWidget);
  });
}
