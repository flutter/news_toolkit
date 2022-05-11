// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('OverlaidImage', () {
    testWidgets('renders correctly', (tester) async {
      final postLargeImage = OverlaidImage(
        imageUrl: 'url',
        gradientColor: Colors.black,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );

      expect(
        find.byKey(const Key('overlaidImage_stack')),
        findsOneWidget,
      );
    });
  });
}
