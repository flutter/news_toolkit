// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class CustomPostBlock extends PostBlock {
  CustomPostBlock({super.action})
      : super(
          id: 'id',
          category: PostCategory.technology,
          author: 'author',
          publishedAt: DateTime(2022, 03, 09),
          title: 'title',
          type: 'type',
        );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

void main() {
  group('PostBlock', () {
    test('can be extended', () {
      expect(CustomPostBlock.new, returnsNormally);
    });
  });

  group('PostBlockActions', () {
    test(
        'hasNavigationAction returns true '
        'when BlockActionType is navigation', () {
      expect(
        CustomPostBlock(
          action: NavigateToArticleAction(articleId: 'articleId'),
        ).hasNavigationAction,
        isTrue,
      );
    });
  });
}
