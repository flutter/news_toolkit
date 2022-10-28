---
sidebar_position: 4
description: Learn how to configure analytics in your Flutter news application.
---

# Analytics

Google Analytics is an app measurement solution, available at no charge, that provides insight on app usage and user engagement.

This project utilizes the `firebase_analytics` package to allow tracking of user activity within the app. To use `firebase_analytics`, it is required to have a Firebase project setup correctly. For instructions on how to add Firebase to your flutter app visit [this site](https://firebase.google.com/docs/flutter/setup).

[AnalyticsRepository](https://github.com/VGVentures/google_news_template/blob/e25b4905604f29f6a2b165b7381e696f4ebc22ee/packages/analytics_repository/lib/src/analytics_repository.dart#L38) is responsible for handling event tracking and can be accessed globally within the app using `BuildContext`

```dart
class AnalyticsRepository {
  const AnalyticsRepository(FirebaseAnalytics analytics)
      : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  /// Tracks the provided [AnalyticsEvent].
  Future<void> track(AnalyticsEvent event) async {
    try {
      await _analytics.logEvent(
        name: event.name,
        parameters: event.properties,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }
  ...
```
