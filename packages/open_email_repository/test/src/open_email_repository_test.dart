import 'package:mocktail/mocktail.dart';
import 'package:open_email_client/open_email_client.dart';
import 'package:open_email_repository/open_email_repository.dart';
import 'package:test/test.dart';

class MockOpenEmailClient extends Mock implements OpenEmailClient {}

void main() {
  late OpenEmailClient openEmailClient;
  late OpenEmailRepository openEmailRepository;

  setUp(() {
    openEmailClient = MockOpenEmailClient();
    openEmailRepository = OpenEmailRepository(openEmailClient: openEmailClient);
  });

  group('OpenEmailRepository', () {
    test('can be instantiated', () {
      expect(OpenEmailRepository(openEmailClient: openEmailClient), isNotNull);
    });

    test('calls to openEmailApp', () async {
      when(() => openEmailClient.openEmailApp()).thenAnswer((_) async {});
      await openEmailRepository.openEmailApp();
      verify(() => openEmailClient.openEmailApp()).called(1);
    });
  });
}
