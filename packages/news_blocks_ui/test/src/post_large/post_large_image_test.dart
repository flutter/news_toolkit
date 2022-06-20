// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostLargeImage', () {
    testWidgets(
        'renders InlineImage '
        'when isContentOverlaid is false', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isContentOverlaid: false,
        isLocked: false,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );
      expect(find.byType(OverlaidImage), findsNothing);
      expect(find.byType(InlineImage), findsOneWidget);
    });

    testWidgets(
        'renders OverlaidImage '
        'when isContentOverlaid is true', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isContentOverlaid: true,
        isLocked: true,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );
      expect(find.byType(InlineImage), findsNothing);
      expect(find.byType(OverlaidImage), findsOneWidget);
    });

    testWidgets(
        'renders LockIcon '
        'when isLocked is true and '
        'when isContentOverlaid is true', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isLocked: true,
        isContentOverlaid: true,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );

      expect(find.byType(LockIcon), findsOneWidget);
    });

    testWidgets(
        'renders LockIcon '
        'when isLocked is true and '
        'when isContentOverlaid is false', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isLocked: true,
        isContentOverlaid: false,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );

      expect(find.byType(LockIcon), findsOneWidget);
    });

    testWidgets(
        'does not render LockIcon '
        'when isLocked is false and '
        'when isContentOverlaid is true', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isLocked: false,
        isContentOverlaid: true,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );

      expect(find.byType(LockIcon), findsNothing);
    });

    testWidgets(
        'does not render LockIcon '
        'when isLocked is false and '
        'when isContentOverlaid is false', (tester) async {
      final postLargeImage = PostLargeImage(
        imageUrl: 'url',
        isLocked: false,
        isContentOverlaid: false,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(postLargeImage),
      );

      expect(find.byType(LockIcon), findsNothing);
    });
  });
}
