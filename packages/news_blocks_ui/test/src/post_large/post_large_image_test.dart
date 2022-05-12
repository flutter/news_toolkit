// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostLargeImage', () {
    testWidgets('renders Image without stack', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isContentOverlaid: false,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );
      expect(find.byKey(Key('overlaidImage_stack')), findsNothing);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders Image in Stack when isContentOverlaid is true',
        (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isContentOverlaid: true,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );
      expect(find.byKey(Key('overlaidImage_stack')), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
