import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

typedef OnAppLinkFunction = void Function(Uri uri, String stringUri);

class MockDeepLinkService extends Mock implements DeepLinkService {}

void main() {
  late DeepLinkService deepLinkServiceMock;
  late StreamController<Uri> onDeepLinkStreamController;

  setUp(() {
    deepLinkServiceMock = MockDeepLinkService();
    onDeepLinkStreamController = StreamController<Uri>();
    when(() => deepLinkServiceMock.deepLinkStream)
        .thenAnswer((_) => onDeepLinkStreamController.stream);
  });

  tearDown(() {
    onDeepLinkStreamController.close();
  });

  group('DeepLinkClient', () {
    test('retrieves and publishes latest link if present', () {
      final expectedUri = Uri.https('ham.app.test', '/test/path');
      when(deepLinkServiceMock.getInitialLink).thenAnswer(
        (_) => Future.value(expectedUri),
      );

      final client = DeepLinkClient(deepLinkService: deepLinkServiceMock);
      expect(client.deepLinkStream, emits(expectedUri));

      // Testing also the replay of the latest value.
      expect(client.deepLinkStream, emits(expectedUri));
    });

    test('publishes DeepLinkClientFailure to stream if upstream throws', () {
      final expectedError = Error();
      final expectedStackTrace = StackTrace.current;

      when(deepLinkServiceMock.getInitialLink).thenAnswer((_) {
        return Future.error(expectedError, expectedStackTrace);
      });

      final client = DeepLinkClient(deepLinkService: deepLinkServiceMock);
      expect(
        client.deepLinkStream,
        emitsError(
          isA<DeepLinkClientFailure>()
              .having((failure) => failure.error, 'error', expectedError),
        ),
      );
    });

    test('publishes values received through onAppLink callback', () {
      final expectedUri1 = Uri.https('ham.app.test', '/test/1');
      final expectedUri2 = Uri.https('ham.app.test', '/test/2');

      when(deepLinkServiceMock.getInitialLink).thenAnswer((_) async => null);

      final client = DeepLinkClient(deepLinkService: deepLinkServiceMock);

      expect(
        client.deepLinkStream,
        emitsInOrder(
          <Uri>[expectedUri1, expectedUri1, expectedUri2, expectedUri1],
        ),
      );

      onDeepLinkStreamController
        ..add(expectedUri1)
        ..add(expectedUri1)
        ..add(expectedUri2)
        ..add(expectedUri1);
    });
  });

  group('DeepLinkClientFailure', () {
    final error = Exception('errorMessage');

    test('has correct props', () {
      expect(
        DeepLinkClientFailure(error).props,
        [error],
      );
    });
  });
}
