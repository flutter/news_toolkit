// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/navigation/navigation.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NavigationDrawerSections', () {
    testWidgets('renders NavigationDrawerSectionsTitle', (tester) async {
      await tester.pumpApp(NavigationDrawerSections());
      expect(find.byType(NavigationDrawerSectionsTitle), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSectionItem', (tester) async {
      await tester.pumpApp(NavigationDrawerSections());
      expect(find.byType(NavigationDrawerSectionItem), findsWidgets);
    });

    group('NavigationDrawerSectionItem', () {
      testWidgets('renders ListTile with title', (tester) async {
        const title = 'title';
        await tester.pumpApp(
          NavigationDrawerSectionItem(
            title: title,
          ),
        );
        expect(find.widgetWithText(ListTile, title), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (tester) async {
        var tapped = false;
        await tester.pumpApp(
          NavigationDrawerSectionItem(
            title: 'title',
            onTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(NavigationDrawerSectionItem));

        expect(tapped, isTrue);
      });

      testWidgets('has correct selected color', (tester) async {
        await tester.pumpApp(
          NavigationDrawerSectionItem(
            title: 'title',
            selected: true,
            onTap: () {},
          ),
        );

        final tile = tester.widget<ListTile>(find.byType(ListTile));

        expect(
          tile.selectedTileColor,
          equals(AppColors.white.withOpacity(0.08)),
        );

        expect(
          (tile.title! as Text).style?.color,
          equals(AppColors.highEmphasisPrimary),
        );
      });
    });
  });
}
