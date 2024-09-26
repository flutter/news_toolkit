// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_deep_link_client/firebase_deep_link_client.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFirebaseDynamicLinks extends Mock implements FirebaseDynamicLinks {}

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

void main() {
  late MockFirebaseDynamicLinks dynamicLinks;
  late StreamController<PendingDynamicLinkData> onLinkStreamController;

  setUp(() {
    dynamicLinks = MockFirebaseDynamicLinks();
    onLinkStreamController = StreamController<PendingDynamicLinkData>();
    when(() => dynamicLinks.onLink)
        .thenAnswer((_) => onLinkStreamController.stream);
  });

  tearDown(() {
    onLinkStreamController.close();
  });

  group('FirebaseDeepLinkClient', () {
    group('getInitialLink', () {
      test('retrieves the latest link if present', () async {
        final expectedUri = Uri.https('ham.app.test', '/test/path');
        when(dynamicLinks.getInitialLink).thenAnswer(
          (_) => Future.value(PendingDynamicLinkData(link: expectedUri)),
        );

        final client =
            FirebaseDeepLinkClient(firebaseDynamicLinks: dynamicLinks);
        final link = await client.getInitialLink();
        expect(link, expectedUri);
      });
    });

    group('deepLinkStream', () {
      test('publishes values received through onLink stream', () {
        final expectedUri1 = Uri.https('news.app.test', '/test/1');
        final expectedUri2 = Uri.https('news.app.test', '/test/2');

        final client =
            FirebaseDeepLinkClient(firebaseDynamicLinks: dynamicLinks);

        onLinkStreamController
          ..add(PendingDynamicLinkData(link: expectedUri1))
          ..add(PendingDynamicLinkData(link: expectedUri1))
          ..add(PendingDynamicLinkData(link: expectedUri2))
          ..add(PendingDynamicLinkData(link: expectedUri1));

        expect(
          client.deepLinkStream,
          emitsInOrder(
            <Uri>[expectedUri1, expectedUri1, expectedUri2, expectedUri1],
          ),
        );
      });
    });
  });
}
