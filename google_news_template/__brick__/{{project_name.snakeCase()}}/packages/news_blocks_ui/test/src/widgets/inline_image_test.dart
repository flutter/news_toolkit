// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('InlineImage', () {
    testWidgets('renders CachedNetworkImage with imageUrl', (tester) async {
      const imageUrl = 'imageUrl';

      ProgressIndicator progressIndicatorBuilder(
        BuildContext context,
        String url,
        DownloadProgress progress,
      ) =>
          ProgressIndicator();

      await mockNetworkImages(
        () async => tester.pumpApp(
          InlineImage(
            imageUrl: imageUrl,
            progressIndicatorBuilder: progressIndicatorBuilder,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is CachedNetworkImage &&
              widget.imageUrl == imageUrl &&
              widget.progressIndicatorBuilder == progressIndicatorBuilder,
        ),
        findsOneWidget,
      );
    });
  });
}
