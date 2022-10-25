// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/app/app.dart';
import 'package:flutter_news_template/article/article.dart';
import 'package:flutter_news_template/slideshow/slideshow.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late ArticleBloc articleBloc;
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

  setUp(() {
    articleBloc = MockArticleBloc();

    when(() => articleBloc.state).thenReturn(ArticleState.initial());
  });
  group('renders ShareButton ', () {
    testWidgets('when url is not empty', (tester) async {
      when(() => articleBloc.state).thenReturn(
        ArticleState.initial().copyWith(uri: Uri(path: 'notEmptyUrl')),
      );
      await mockNetworkImages(
        () async => tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: SlideshowView(
              block: slideshow,
            ),
          ),
        ),
      );
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('that adds ShareRequested on ShareButton tap', (tester) async {
      when(() => articleBloc.state).thenReturn(
        ArticleState.initial().copyWith(
          uri: Uri(path: 'notEmptyUrl'),
        ),
      );
      await mockNetworkImages(
        () async => tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: SlideshowView(
              block: slideshow,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ShareButton));

      verify(
        () => articleBloc.add(
          ShareRequested(
            uri: Uri(path: 'notEmptyUrl'),
          ),
        ),
      ).called(1);
    });
  });

  group('does not render ShareButton', () {
    testWidgets('when url is empty', (tester) async {
      await mockNetworkImages(
        () async => tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: SlideshowView(
              block: slideshow,
            ),
          ),
        ),
      );
      expect(find.byType(ShareButton), findsNothing);
    });
  });

  testWidgets('renders ArticleSubscribeButton', (tester) async {
    await mockNetworkImages(
      () async => tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SlideshowView(
            block: slideshow,
          ),
        ),
      ),
    );
    expect(find.byType(ArticleSubscribeButton), findsOneWidget);
  });

  group('ArticleSubscribeButton', () {
    testWidgets('renders AppButton', (tester) async {
      await tester.pumpApp(
        Row(
          children: [ArticleSubscribeButton()],
        ),
      );
      expect(find.byType(AppButton), findsOneWidget);
    });
  });
}
