import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// {@template ads_consent_failure}
/// A base failure for the ads consent client failures.
/// {@endtemplate}
abstract class AdsContentFailure implements Exception {
  /// {@macro ads_consent_failure}
  const AdsContentFailure(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template request_ads_consent_failure}
/// Thrown when requesting ads consent fails.
/// {@endtemplate}
class RequestConsentFailure extends AdsContentFailure {
  /// {@macro request_ads_consent_failure}
  const RequestConsentFailure(super.error);
}

/// Signature for the content form provider.
typedef ConsentFormProvider = void Function(
  OnConsentFormLoadSuccessListener successListener,
  OnConsentFormLoadFailureListener failureListener,
);

/// {@template ads_consent_client}
/// A client that handles requesting ads consent on a device.
/// {@endtemplate}
class AdsConsentClient {
  /// {@macro ads_consent_client}
  AdsConsentClient({
    ConsentInformation? adsConsentInformation,
    ConsentFormProvider? adsConsentFormProvider,
  })  : _adsConsentInformation =
            adsConsentInformation ?? ConsentInformation.instance,
        _adsConsentFormProvider =
            adsConsentFormProvider ?? ConsentForm.loadConsentForm;

  final ConsentInformation _adsConsentInformation;
  final ConsentFormProvider _adsConsentFormProvider;

  /// Requests the ads consent by presenting the consent form
  /// if user consent is required but not yet obtained.
  ///
  /// Returns true if the consent was determined.
  ///
  /// Throws a [RequestConsentFailure] if an exception occurs.
  Future<bool> requestConsent() {
    final adsConsentDeterminedCompleter = Completer<bool>();

    _adsConsentInformation.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        try {
          if (await _adsConsentInformation.isConsentFormAvailable()) {
            adsConsentDeterminedCompleter.complete(await _loadConsentForm());
          } else {
            final status = await _adsConsentInformation.getConsentStatus();
            adsConsentDeterminedCompleter.complete(status.isDetermined);
          }
        } on FormError catch (error, stackTrace) {
          _onRequestConsentError(
            error,
            completer: adsConsentDeterminedCompleter,
            stackTrace: stackTrace,
          );
        }
      },
      (error) => _onRequestConsentError(
        error,
        completer: adsConsentDeterminedCompleter,
      ),
    );

    return adsConsentDeterminedCompleter.future;
  }

  Future<bool> _loadConsentForm() async {
    final completer = Completer<bool>();

    _adsConsentFormProvider(
      (consentForm) async {
        final status = await _adsConsentInformation.getConsentStatus();
        if (status.isRequired) {
          consentForm.show(
            (error) async {
              if (error != null) {
                completer.completeError(error, StackTrace.current);
              } else {
                final updatedStatus =
                    await _adsConsentInformation.getConsentStatus();
                completer.complete(updatedStatus.isDetermined);
              }
            },
          );
        } else {
          completer.complete(status.isDetermined);
        }
      },
      (error) => completer.completeError(error, StackTrace.current),
    );

    return completer.future;
  }

  void _onRequestConsentError(
    FormError error, {
    required Completer<bool> completer,
    StackTrace? stackTrace,
  }) =>
      completer.completeError(
        RequestConsentFailure(error),
        stackTrace ?? StackTrace.current,
      );
}

extension on ConsentStatus {
  /// Whether the user has consented to the use of personalized ads
  /// or the consent is not required, e.g. the user is not in the EEA or UK.
  bool get isDetermined =>
      this == ConsentStatus.obtained || this == ConsentStatus.notRequired;

  /// Whether the consent to the user of personalized ads is required.
  bool get isRequired => this == ConsentStatus.required;
}
