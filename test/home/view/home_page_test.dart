// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/home/home.dart';

import '../../helpers/helpers.dart';

void main() {
  test('has a page', () {
    expect(HomePage.page(), isA<MaterialPage>());
  });

  testWidgets('renders a HomeView', (tester) async {
    await tester.pumpApp(const HomePage());
    expect(find.byType(HomeView), findsOneWidget);
  });
}
