// ignore_for_file: prefer_const_constructors, avoid_dynamic_calls

import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mocktail/mocktail.dart';

class MockConsentInformation extends Mock implements ConsentInformation {}

class MockConsentForm extends Mock implements ConsentForm {}

void main() {
  group('AdsConsentClient', () {
    late ConsentInformation adsConsentInformation;
    late ConsentFormProvider adsConsentFormProvider;
    late ConsentForm adsConsentForm;

    setUp(() {
      adsConsentInformation = MockConsentInformation();
      adsConsentFormProvider = (successListener, failureListener) async {};
      adsConsentForm = MockConsentForm();
    });

    test('can be instantiated', () async {
      expect(AdsConsentClient.new, returnsNormally);
    });

    group('requestConsent', () {
      group(
          'when ConsentInformation.requestConsentInfoUpdate succeeds '
          'and ConsentInformation.isConsentFormAvailable returns true', () {
        setUp(() {
          when(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).thenAnswer(
            (invocation) {
              final successListener = invocation.positionalArguments[1];
              successListener();
            },
          );

          when(adsConsentInformation.isConsentFormAvailable)
              .thenAnswer((_) async => true);
        });

        group(
            'and ConsentInformation.getConsentStatus returns required '
            'and ConsentForm.show succeeds', () {
          setUp(() {
            adsConsentFormProvider = (successListener, failureListener) async {
              when(adsConsentInformation.getConsentStatus)
                  .thenAnswer((_) async => ConsentStatus.required);
              successListener(adsConsentForm);
            };
          });

          test('returns true if consent status was obtained', () async {
            const updatedConsentStatus = ConsentStatus.obtained;

            when(() => adsConsentForm.show(any())).thenAnswer((invocation) {
              // Update consent status to obtained
              // when the consent form is dismissed.
              when(adsConsentInformation.getConsentStatus)
                  .thenAnswer((_) async => updatedConsentStatus);

              final dismissedListener = invocation.positionalArguments.first;
              dismissedListener(null);
            });

            final adsConsentDetermined = await AdsConsentClient(
              adsConsentInformation: adsConsentInformation,
              adsConsentFormProvider: adsConsentFormProvider,
            ).requestConsent();

            verify(
              () => adsConsentInformation.requestConsentInfoUpdate(
                ConsentRequestParameters(),
                any(),
                any(),
              ),
            ).called(1);
            verify(adsConsentInformation.isConsentFormAvailable).called(1);
            verify(adsConsentInformation.getConsentStatus).called(2);
            verify(() => adsConsentForm.show(any())).called(1);

            expect(adsConsentDetermined, isTrue);
          });

          test('returns false if consent status was not obtained', () async {
            const updatedConsentStatus = ConsentStatus.unknown;

            when(() => adsConsentForm.show(any())).thenAnswer((invocation) {
              // Update consent status to unknown
              // when the consent form is dismissed.
              when(adsConsentInformation.getConsentStatus)
                  .thenAnswer((_) async => updatedConsentStatus);

              final dismissedListener = invocation.positionalArguments.first;
              dismissedListener(null);
            });

            final adsConsentDetermined = await AdsConsentClient(
              adsConsentInformation: adsConsentInformation,
              adsConsentFormProvider: adsConsentFormProvider,
            ).requestConsent();

            verify(
              () => adsConsentInformation.requestConsentInfoUpdate(
                ConsentRequestParameters(),
                any(),
                any(),
              ),
            ).called(1);
            verify(adsConsentInformation.isConsentFormAvailable).called(1);
            verify(adsConsentInformation.getConsentStatus).called(2);
            verify(() => adsConsentForm.show(any())).called(1);

            expect(adsConsentDetermined, isFalse);
          });
        });

        group(
            'and ConsentInformation.getConsentStatus returns required '
            'and ConsentForm.show fails', () {
          setUp(() {
            adsConsentFormProvider = (successListener, failureListener) async {
              when(adsConsentInformation.getConsentStatus)
                  .thenAnswer((_) async => ConsentStatus.required);
              successListener(adsConsentForm);
            };

            when(() => adsConsentForm.show(any())).thenAnswer((invocation) {
              final dismissedListener = invocation.positionalArguments.first;
              dismissedListener(FormError(errorCode: 1, message: 'message'));
            });
          });

          test('throws a RequestConsentFailure', () async {
            expect(
              AdsConsentClient(
                adsConsentInformation: adsConsentInformation,
                adsConsentFormProvider: adsConsentFormProvider,
              ).requestConsent,
              throwsA(isA<RequestConsentFailure>()),
            );
          });
        });

        group(
            'and ConsentInformation.getConsentStatus returns required '
            'and ConsentFormProvider fails', () {
          setUp(() {
            adsConsentFormProvider = (successListener, failureListener) async {
              failureListener(FormError(errorCode: 1, message: 'message'));
            };
          });

          test('throws a RequestConsentFailure', () async {
            expect(
              AdsConsentClient(
                adsConsentInformation: adsConsentInformation,
                adsConsentFormProvider: adsConsentFormProvider,
              ).requestConsent,
              throwsA(isA<RequestConsentFailure>()),
            );
          });
        });

        test(
            'returns true '
            'when ConsentInformation.getConsentStatus returns notRequired',
            () async {
          adsConsentFormProvider = (successListener, failureListener) async {
            when(adsConsentInformation.getConsentStatus)
                .thenAnswer((_) async => ConsentStatus.notRequired);
            successListener(adsConsentForm);
          };

          final adsConsentDetermined = await AdsConsentClient(
            adsConsentInformation: adsConsentInformation,
            adsConsentFormProvider: adsConsentFormProvider,
          ).requestConsent();

          verify(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).called(1);
          verify(adsConsentInformation.isConsentFormAvailable).called(1);
          verify(adsConsentInformation.getConsentStatus).called(1);

          expect(adsConsentDetermined, isTrue);
        });

        test(
            'returns true '
            'when ConsentInformation.getConsentStatus returns obtained',
            () async {
          adsConsentFormProvider = (successListener, failureListener) async {
            when(adsConsentInformation.getConsentStatus)
                .thenAnswer((_) async => ConsentStatus.obtained);
            successListener(adsConsentForm);
          };

          final adsConsentDetermined = await AdsConsentClient(
            adsConsentInformation: adsConsentInformation,
            adsConsentFormProvider: adsConsentFormProvider,
          ).requestConsent();

          verify(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).called(1);
          verify(adsConsentInformation.isConsentFormAvailable).called(1);
          verify(adsConsentInformation.getConsentStatus).called(1);

          expect(adsConsentDetermined, isTrue);
        });

        test(
            'returns false '
            'when ConsentInformation.getConsentStatus returns unknown',
            () async {
          adsConsentFormProvider = (successListener, failureListener) async {
            when(adsConsentInformation.getConsentStatus)
                .thenAnswer((_) async => ConsentStatus.unknown);
            successListener(adsConsentForm);
          };

          final adsConsentDetermined = await AdsConsentClient(
            adsConsentInformation: adsConsentInformation,
            adsConsentFormProvider: adsConsentFormProvider,
          ).requestConsent();

          verify(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).called(1);
          verify(adsConsentInformation.isConsentFormAvailable).called(1);
          verify(adsConsentInformation.getConsentStatus).called(1);

          expect(adsConsentDetermined, isFalse);
        });
      });

      group(
          'when ConsentInformation.requestConsentInfoUpdate succeeds '
          'and ConsentInformation.isConsentFormAvailable returns false', () {
        setUp(() {
          when(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).thenAnswer(
            (invocation) {
              final successListener = invocation.positionalArguments[1];
              successListener();
            },
          );

          when(adsConsentInformation.isConsentFormAvailable)
              .thenAnswer((_) async => false);
        });

        test(
            'returns true '
            'when ConsentInformation.getConsentStatus returns notRequired',
            () async {
          when(adsConsentInformation.getConsentStatus)
              .thenAnswer((_) async => ConsentStatus.notRequired);

          final adsConsentDetermined = await AdsConsentClient(
            adsConsentInformation: adsConsentInformation,
            adsConsentFormProvider: adsConsentFormProvider,
          ).requestConsent();

          verify(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).called(1);
          verify(adsConsentInformation.isConsentFormAvailable).called(1);
          verify(adsConsentInformation.getConsentStatus).called(1);

          expect(adsConsentDetermined, isTrue);
        });

        test(
            'returns true '
            'when ConsentInformation.getConsentStatus returns obtained',
            () async {
          when(adsConsentInformation.getConsentStatus)
              .thenAnswer((_) async => ConsentStatus.obtained);

          final adsConsentDetermined = await AdsConsentClient(
            adsConsentInformation: adsConsentInformation,
            adsConsentFormProvider: adsConsentFormProvider,
          ).requestConsent();

          verify(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).called(1);
          verify(adsConsentInformation.isConsentFormAvailable).called(1);
          verify(adsConsentInformation.getConsentStatus).called(1);

          expect(adsConsentDetermined, isTrue);
        });

        test(
            'returns false '
            'when ConsentInformation.getConsentStatus returns unknown',
            () async {
          when(adsConsentInformation.getConsentStatus)
              .thenAnswer((_) async => ConsentStatus.unknown);

          final adsConsentDetermined = await AdsConsentClient(
            adsConsentInformation: adsConsentInformation,
            adsConsentFormProvider: adsConsentFormProvider,
          ).requestConsent();

          verify(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).called(1);
          verify(adsConsentInformation.isConsentFormAvailable).called(1);
          verify(adsConsentInformation.getConsentStatus).called(1);

          expect(adsConsentDetermined, isFalse);
        });
      });

      group('when ConsentInformation.requestConsentInfoUpdate fails', () {
        setUp(() {
          when(
            () => adsConsentInformation.requestConsentInfoUpdate(
              ConsentRequestParameters(),
              any(),
              any(),
            ),
          ).thenAnswer(
            (invocation) {
              final failureListener = invocation.positionalArguments.last;
              failureListener(FormError(errorCode: 1, message: 'message'));
            },
          );
        });

        test('throws a RequestConsentFailure', () async {
          expect(
            AdsConsentClient(
              adsConsentInformation: adsConsentInformation,
              adsConsentFormProvider: adsConsentFormProvider,
            ).requestConsent,
            throwsA(isA<RequestConsentFailure>()),
          );
        });
      });
    });
  });
}
