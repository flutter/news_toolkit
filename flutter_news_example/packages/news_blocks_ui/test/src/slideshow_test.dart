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
  const slideshowPageViewKey = Key('slideshow_pageView');
  const slideshowItemImageKey = Key('slideshow_slideshowItemImage');
  const slideshowItemCaptionKey = Key('slideshow_slideshowItemCaption');
  const slideshowItemDescriptionKey = Key('slideshow_slideshowItemDescription');
  const slideshowItemPhotoCreditKey = Key('slideshow_slideshowItemPhotoCredit');
  const slideshowButtonsLeftKey = Key('slideshow_slideshowButtonsLeft');
  const slideshowButtonsRightKey = Key('slideshow_slideshowButtonsRight');

  group('Slideshow', () {
    const pageAnimationDuration = Duration(milliseconds: 300);

    final slides = List.generate(
      3,
      (index) => SlideBlock(
        caption: 'Oink, Oink',
        description: 'Domestic pigs come in different colors, '
            'shapes and sizes. They are usually pink, but little pigs kept as'
            ' pets (pot-bellied pigs) are sometimes other colors. '
            ' Pigs roll in mud to protect themselves from sunlight. '
            ' Many people think that pigs are dirty and smell. In fact,'
            ' they roll around in the mud to keep bugs '
            ' and ticks away from their skin. '
            ' This also helps to keep their skin moist and lower their body'
            ' temperature on hot days. They are omnivores, '
            ' which means that they eat both plants and animals.',
        photoCredit: 'Photo Credit: Pascal',
        imageUrl:
            'https://media.4-paws.org/9/4/f/5/94f5197df88687ce362e32f23b926f0a246c1b54/VIER%20PFOTEN_2016-11-16_028%20%281%29-1843x1275.jpg',
      ),
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
              navigationLabel: 'of',
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
              navigationLabel: 'of',
            ),
          ),
        );

        expect(find.byKey(slideshowHeaderKey), findsOneWidget);
      });

      testWidgets('slideshow page view', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
              navigationLabel: 'of',
            ),
          ),
        );

        expect(find.byKey(slideshowPageViewKey), findsOneWidget);
      });

      testWidgets('slideshow item image', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
              navigationLabel: 'of',
            ),
          ),
        );

        expect(find.byKey(slideshowItemImageKey), findsOneWidget);
      });

      testWidgets('slideshow item caption', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
              navigationLabel: 'of',
            ),
          ),
        );

        expect(find.byKey(slideshowItemCaptionKey), findsOneWidget);
      });

      testWidgets('slideshow item description', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
              navigationLabel: 'of',
            ),
          ),
        );

        expect(find.byKey(slideshowItemDescriptionKey), findsOneWidget);
      });

      testWidgets('slideshow item photo credit', (tester) async {
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            Slideshow(
              block: SlideshowBlock(
                title: 'Pigs through history',
                slides: slides,
              ),
              categoryTitle: 'SLIDESHOW',
              navigationLabel: 'of',
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
              navigationLabel: 'of',
            ),
          ),
        );

        final nextPageButton = find.byKey(slideshowButtonsRightKey);

        // Set page 2
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(pageAnimationDuration);
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(pageAnimationDuration);

        final previousPageButton = find.byKey(slideshowButtonsLeftKey);
        final slideshowItem = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[2],
        );

        expect(slideshowItem, findsOneWidget);

        final currentPage = tester
            .widget<PageView>(find.byKey(slideshowPageViewKey))
            .controller
            ?.page;

        // Check current page
        expect(currentPage, 2);

        await tester.tap(previousPageButton);
        await tester.pumpAndSettle(pageAnimationDuration);

        final slideshowItemPrevious = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[1],
        );
        expect(slideshowItemPrevious, findsOneWidget);
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
              navigationLabel: 'of',
            ),
          ),
        );

        final nextPageButton = find.byKey(slideshowButtonsRightKey);

        // Set page 1
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(pageAnimationDuration);

        final slideshowItem = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[1],
        );

        final currentPage = tester
            .widget<PageView>(find.byKey(slideshowPageViewKey))
            .controller
            ?.page;

        // Check current page
        expect(currentPage, 1);

        expect(slideshowItem, findsOneWidget);

        await tester.tap(nextPageButton);
        await tester.pumpAndSettle(pageAnimationDuration);

        final slideshowItemNext = find.byWidgetPredicate(
          (widget) => widget is SlideshowItem && widget.slide == slides[2],
        );

        expect(slideshowItemNext, findsOneWidget);
      });
    });
  });
}
