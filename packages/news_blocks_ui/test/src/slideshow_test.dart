// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/pump_content_themed_app.dart';

void main() {
  const slideshowCategoryTitleKey = Key('slideshow_categoryTitle');
  const slideshowHeaderKey = Key('slideshow_headerTitle');
  const slideshowPageViewKey = Key('slideshow_pageview');
  const slideshowItemImageKey = Key('slideshow_slideshowItemImage');
  const slideshowItemCaptionKey = Key('slideshow_slideshowItemCaption');
  const slideshowItemDescriptionKey = Key('slideshow_slideshowItemDescription');
  const slideshowItemPhotoCreditKey = Key('slideshow_slideshowItemPhotoCredit');
  const slideshowButtonsLeftKey = Key('slideshow_slideshowButtonsLeft');
  const slideshowButtonsRightKey = Key('slideshow_slideshowButtonsRight');

  group('Slideshow', () {
    const _pageAnimationDuration = Duration(milliseconds: 300);

    final slides = List.generate(
      4,
      (index) => SlideBlock(
          caption: 'Oink, Oink',
          description:
              'Pigs facts! Fusce ornare quis odio eget fringilla.Curabitur'
              ' gravida velit urna, semper imperdiet metus fermentum '
              'congue. Vestibulum ut diam ut risus porta mattis. Proin '
              'fringilla arcu lorem, sit amet porttitor ante iaculis sit '
              'amet.',
          photoCredit: 'Photo Credit: Pascal Debrunner',
          imageUrl:
              'https://media.4-paws.org/9/4/f/5/94f5197df88687ce362e32f23b926f0a246c1b54/VIER%20PFOTEN_2016-11-16_028%20%281%29-1843x1275.jpg'),
    );

    group('renders', () {
      testWidgets('slideshow category title', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs trough history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowCategoryTitleKey), findsOneWidget);
      });

      testWidgets('slideshow header title', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowHeaderKey), findsOneWidget);
      });

      testWidgets('slidehow page view', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowPageViewKey), findsOneWidget);
      });

      testWidgets('slidehow item image', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowItemImageKey), findsOneWidget);
      });

      testWidgets('slidehow item caption', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowItemCaptionKey), findsOneWidget);
      });

      testWidgets('slidehow item description', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowItemDescriptionKey), findsOneWidget);
      });

      testWidgets('slidehow item photo credit', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        expect(find.byKey(slideshowItemPhotoCreditKey), findsOneWidget);
      });
    });

    group('onPageChanged', () {
      testWidgets('when use previous button', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        final nextPageButton = find.byKey(slideshowButtonsRightKey);

        // Set page 2
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(_pageAnimationDuration);
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(_pageAnimationDuration);

        final previousPageButton = find.byKey(slideshowButtonsLeftKey);
        final slideshowItem = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[2],
        );

        expect(slideshowItem, findsOneWidget);

        final currentPage = tester
            .widget<PageView>(find.byKey(slideshowPageViewKey))
            .controller
            .page;

        // Check current page
        expect(currentPage, 2);

        await tester.tap(previousPageButton);
        await tester.pumpAndSettle(_pageAnimationDuration);

        final slidehowItemPrevious = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[1],
        );
        expect(slidehowItemPrevious, findsOneWidget);
      });

      testWidgets('when use next button', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
            ),
          ),
        );

        final nextPageButton = find.byKey(slideshowButtonsRightKey);

        // Set page 1
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(_pageAnimationDuration);

        final slideshowItem = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[1],
        );

        final currentPage = tester
            .widget<PageView>(find.byKey(slideshowPageViewKey))
            .controller
            .page;

        // Check current page
        expect(currentPage, 1);

        expect(slideshowItem, findsOneWidget);

        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(_pageAnimationDuration);

        final slidehowItemNext = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[2],
        );

        expect(slidehowItemNext, findsOneWidget);
      });
    });
  });
}
