// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

void main() {
  group('AdsRetryPolicy', () {
    test('has correct initial values', () {
      final adsRetryPolicy = AdsRetryPolicy();
      expect(adsRetryPolicy.maxRetryCount, equals(3));
      expect(
        adsRetryPolicy.retryIntervals,
        equals([
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ]),
      );
    });

    group('getIntervalForRetry', () {
      test('returns correct values', () {
        final adsRetryPolicy = AdsRetryPolicy();
        expect(
          adsRetryPolicy.getIntervalForRetry(0),
          equals(Duration.zero),
        );
        for (var i = 1; i <= adsRetryPolicy.maxRetryCount; i++) {
          expect(
            adsRetryPolicy.getIntervalForRetry(i),
            adsRetryPolicy.retryIntervals[i - 1],
          );
        }
        expect(
          adsRetryPolicy.getIntervalForRetry(adsRetryPolicy.maxRetryCount + 1),
          equals(Duration.zero),
        );
      });
    });
  });
}
