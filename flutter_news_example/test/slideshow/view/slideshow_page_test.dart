// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/slideshow/slideshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  initMockHydratedStorage();
  late GoRouterState goRouterState;
  late BuildContext context;

  setUp(() {
    goRouterState = _MockGoRouterState();
    context = _MockBuildContext();
  });

  group('SlideshowPage', () {
    const articleId = 'articleId';
    final slides = List.generate(
      4,
      (index) => SlideBlock(
        caption: 'caption',
        description: 'description',
        photoCredit: 'photo credit',
        imageUrl: 'imageUrl',
      ),
    );
    final slideshow = SlideshowBlock(title: 'title', slides: slides);

    testWidgets('routeBuilder builds a SlideshowPage', (tester) async {
      when(() => goRouterState.pathParameters).thenReturn({'id': 'id'});
      when(() => goRouterState.extra)
          .thenReturn(const SlideshowBlock(title: 'title', slides: []));

      final page = SlideshowPage.routeBuilder(context, goRouterState);

      expect(page, isA<SlideshowPage>());
    });

    testWidgets('renders a SlideshowView', (tester) async {
      await mockNetworkImages(
        () => tester.pumpApp(
          SlideshowPage(
            slideshow: slideshow,
            articleId: articleId,
          ),
        ),
      );

      expect(find.byType(SlideshowView), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when leading button is pressed.', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenAnswer((_) => true);
        when(() => navigator.popUntil(any())).thenAnswer((_) async {});
        await mockNetworkImages(
          () => tester.pumpApp(
            SlideshowPage(
              slideshow: slideshow,
              articleId: articleId,
            ),
            navigator: navigator,
          ),
        );

        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();
        verify(navigator.pop);
      });
    });
  });
}
