// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/user_profile/user_profile.dart';

import '../../helpers/helpers.dart';

void main() {
  group('UserProfileSubscribeBox', () {
    testWidgets('calls onSubscribePressed when AppButton tapped',
        (tester) async {
      final completer = Completer<void>();
      await tester.pumpApp(
        UserProfileSubscribeBox(onSubscribePressed: completer.complete),
      );

      await tester.tap(find.byKey(Key('userProfileSubscribeBox_appButton')));

      expect(completer.isCompleted, isTrue);
    });
  });
}
