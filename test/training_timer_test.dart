import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cubetrainer/widgets/training_timer.dart';

void main() {
  group('TrainingTimer Inspection Tests', () {
    testWidgets('Should start with 15s inspection when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TrainingTimer(
            onStart: () {},
            onStop: (_) {},
            useInspection: true,
          ),
        ),
      ));

      expect(find.text('ISPEZIONE'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets(
        'Starting and skipping inspection should transition timer to READY',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TrainingTimer(
            onStart: () {},
            onStop: (_) {},
            useInspection: true,
          ),
        ),
      ));

      await tester.tap(find.text('AVVIA TIMER ISPEZIONE'));
      await tester.pump();

      expect(find.text('ISPEZIONE IN CORSO'), findsOneWidget);

      await tester.tap(find.text('SALTA (PRONTO)'));
      await tester.pump();

      expect(find.text('ISPEZIONE'), findsNothing);
      expect(find.text('TIENI PREMUTO PER INIZIARE'), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);
    });

    testWidgets('Long press during READY should arm the timer',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TrainingTimer(
            onStart: () {},
            onStop: (_) {},
            useInspection: false, // Start directly in READY
          ),
        ),
      ));

      expect(find.text('TIENI PREMUTO PER INIZIARE'), findsOneWidget);

      // Simulate long press down
      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(TrainingTimer)));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('RILASCIA PER PARTIRE'), findsOneWidget);

      // Release to start
      await gesture.up();
      await tester.pump();

      expect(find.text('RILASCIA PER PARTIRE'), findsNothing);
    });
  });
}
