import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

typedef OnAppLinkFunction = void Function(Uri uri, String stringUri);

class MockDeepLinkClient extends Mock implements DeepLinkClient {}

void main() {
  late DeepLinkClient deepLinkClient;
  late StreamController<Uri> onDeepLinkStreamController;

  setUp(() {
    deepLinkClient = MockDeepLinkClient();
    onDeepLinkStreamController = StreamController<Uri>();
    when(() => deepLinkClient.deepLinkStream)
        .thenAnswer((_) => onDeepLinkStreamController.stream);
  });

  tearDown(() {
    onDeepLinkStreamController.close();
  });

  group('DeepLinkService', () {
    test('retrieves and publishes latest link if present', () {
      final expectedUri = Uri.https('ham.app.test', '/test/path');
      when(deepLinkClient.getInitialLink).thenAnswer(
        (_) => Future.value(expectedUri),
      );

      final service = DeepLinkService(deepLinkClient: deepLinkClient);
      expect(service.deepLinkStream, emits(expectedUri));

      // Testing also the replay of the latest value.
      expect(service.deepLinkStream, emits(expectedUri));
    });

    test('publishes DeepLinkClientFailure to stream if upstream throws', () {
      final expectedError = Error();
      final expectedStackTrace = StackTrace.current;

      when(deepLinkClient.getInitialLink).thenAnswer((_) {
        return Future.error(expectedError, expectedStackTrace);
      });

      final deepLinkService = DeepLinkService(deepLinkClient: deepLinkClient);
      expect(
        deepLinkService.deepLinkStream,
        emitsError(
          isA<DeepLinkClientFailure>()
              .having((failure) => failure.error, 'error', expectedError),
        ),
      );
    });

    test('publishes values received through onAppLink callback', () {
      final expectedUri1 = Uri.https('ham.app.test', '/test/1');
      final expectedUri2 = Uri.https('ham.app.test', '/test/2');

      when(deepLinkClient.getInitialLink).thenAnswer((_) async => null);

      final deepLinkService = DeepLinkService(deepLinkClient: deepLinkClient);

      expect(
        deepLinkService.deepLinkStream,
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
