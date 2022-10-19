// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  const tapMeText = 'Tap Me';

  group('NetworkErrorAlert', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        NetworkErrorAlert(
          errorText: 'errorText',
          refreshButtonText: 'refreshButtonText',
        ),
      );

      expect(find.byType(NetworkErrorAlert), findsOneWidget);
    });

    testWidgets('router returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    NetworkErrorAlert.route(
                      errorText: 'errorText',
                      refreshButtonText: 'refreshButtonText',
                    ),
                  );
                },
                child: const Text(tapMeText),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text(tapMeText));
      await tester.pumpAndSettle();

      expect(find.byType(NetworkErrorAlert), findsOneWidget);
    });
  });
}
