// Basic smoke test for the Loan Tracking App.

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_tracking_app/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoanTrackerApp());
    // Just ensure it renders without throwing.
    expect(tester.takeException(), isNull);
  });
}
