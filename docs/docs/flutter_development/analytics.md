---
sidebar_position: 5
description: Learn how to configure analytics in your Flutter news application.
---

# Analytics

Google Analytics is an app measurement solution, available at no charge, that provides insight on app usage and user engagement.

This project uses the `firebase_analytics` package to track user activity within the app. To use `firebase_analytics`, you must have a Firebase project setup correctly. For instructions on how to add Firebase to your flutter app, check out [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup).

The [AnalyticsRepository](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/packages/analytics_repository/lib/src/analytics_repository.dart#L38) handles event tracking and can be accessed globally within the app using `BuildContext`:

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
