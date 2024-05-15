// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('UserProfileDeleteAccountDialog', () {
    late AppBloc appBloc;

    final cancelButton = find.byKey(
      const Key('userProfilePage_cancelDeleteAccountButton'),
    );
    final deleteAccountButton = find.byKey(
      const Key('userProfilePage_deleteAccountButton'),
    );

    setUp(() {
      appBloc = MockAppBloc();
    });

    testWidgets('renders cancel and delete account buttons', (tester) async {
      await tester.pumpApp(
        UserProfileDeleteAccountDialog(),
        appBloc: appBloc,
      );

      expect(cancelButton, findsOneWidget);
      expect(deleteAccountButton, findsOneWidget);
    });

    testWidgets('closes dialog when cancel button is pressed', (tester) async {
      final navigator = MockNavigator();
      when(navigator.canPop).thenAnswer((_) => true);
      when(navigator.pop).thenAnswer((_) async {});

      await tester.pumpApp(
        Scaffold(body: UserProfileDeleteAccountDialog()),
        appBloc: appBloc,
        navigator: navigator,
      );

      expect(cancelButton, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(cancelButton);

      verify(navigator.pop).called(1);
    });

    testWidgets(
        'adds AppDeleteAccountRequested to AppBloc and closes dialog '
        'when delete account button is pressed', (tester) async {
      final navigator = MockNavigator();
      when(navigator.canPop).thenAnswer((_) => true);
      when(navigator.pop).thenAnswer((_) async {});

      await tester.pumpApp(
        Scaffold(body: UserProfileDeleteAccountDialog()),
        appBloc: appBloc,
        navigator: navigator,
      );

      expect(cancelButton, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(deleteAccountButton);

      verify(() => appBloc.add(const AppDeleteAccountRequested())).called(1);
      verify(navigator.pop).called(1);
    });
  });
}
