// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppDivider', () {
    testWidgets('renders Divider', (tester) async {
      await tester.pumpApp(AppDivider());
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
