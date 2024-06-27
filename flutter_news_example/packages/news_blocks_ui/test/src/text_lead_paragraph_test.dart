// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('TextLeadParagraph', () {
    setUpAll(
      () => setUpTolerantComparator('test/src/text_lead_paragraph_test.dart'),
    );

    testWidgets('renders correctly', (tester) async {
      final widget = Center(
        child: TextLeadParagraph(
          block: TextLeadParagraphBlock(text: 'Text Lead Paragraph'),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(TextLeadParagraph),
        matchesGoldenFile('text_lead_paragraph.png'),
      );
    });
  });
}
