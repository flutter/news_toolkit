---
sidebar_position: 2
---

# Project Roadmap

Below is an example project roadmap that can be leveraged to implement this template for your very own Flutter application. Please use this as a guide for your development efforts and deviate where necessary.

## Initial Configuration

- Follow the configuration steps outlined in [this section](#configuration) before starting your project. These steps will ensure your project is set-up appropriately and will supply your team with the necessary keys required for your application.

## Code Generation

- After completing your pre-project setup and configuration, [generate your codebase](#generating-your-codebase-with-mason) using [mason](https://pub.dev/packages/mason).
- The [Google News Template](https://github.com/kaiceyd/news_template/blob/patch-1/google_news_template/README.md) supports the following decision points:
  - Application name (_e.g. News Template_)
  - Application package name (_e.g. news_template_)
  - Desired Flutter version
  - Application bundle identifier (_e.g. com.news.template_)
  - Code Owners
  - Flavors, where each flavor includes a different:
    - Application suffix (appended to the application bundle identifier for a given flavor)
    - Deep link domain (used to navigate from the app from email login link, configured from the Firebase Console)
    - Twitter configuration (API key and API secret; used to login with Twitter)
    - Facebook configuration (App ID, client token and display name; used to login with Facebook)
    - Google Ad Manager or Admob configuration (App ID for iOS and Android; used to display ads)

## Google Play Store

- [Set up API access](https://play.google.com/console/u/0/developers/6749221870414263141/api-access)

## Translations

This project relies on [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) and follows the [official internationalization guide for Flutter](https://flutter.dev/docs/development/accessibility-and-localization/internationalization). If you would like to support a different language (or multiple languages) in your app, please review [this section](#working-with-translations) for instruction.

## Theming & Branding

- Update your app's [splash screen](#updating-the-app-splash-screen).
- Update your app's [launcher icons](#updating-the-app-launcher-icon).

  - If you'd like to support [adaptive icons for Android](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive), ensure you have background and foreground assets.

- Update the [app logo in the top navigation bar](#updating-the-app-logo).
- Update the app's [colors](#updating-app-colors) via the app's [theme](#updating-theme-colors) and [in-line color references](#updating-inline-colors).
- Update the app's [typography](#updating-the-app-typography).
- Update the app's [Privacy Policy and/or Terms of Service](#updating-the-privacy-policy-&-terms-of-service) in the app's settings and authentication screens.

## Data Source & Feature Implementation

- Once the app is starting to reflect your brand, you'll want to [implement your API datasource](#implementing-an-api-data-source).
- Next, you'll need to [set-up backend adapters](#implementing-backend-adapters) for each of the following endpoints:

  - getArticle
  - getFeed
  - getCategories
  - getTrendingStory
  - getSubscriptions
  - getRelatedArticles
  - getReleventTopics (search)
  - getReleventArticles (search)
  - getPopularArticles (search)
  - getPopularTopics (search)
  - subscribeToNewsletter

- You'll also want to [implement push notifications](#push-notifications) using either FCM or OneSignal and update the UI to support the categories of notifications that you'd like to enable.
- [Organize and adjust your blocks](#organizing-and-adjusting-blocks) in your content feed and article pages to create a customized look and feel for your app.
- Finally, [make any adjustments to the ads logic](#updating-ads-placement) to match your organization's requirements.

## API Deployment & Versioning

- After ensuring your dev and production api have been successfully [deployed on Cloud Run](#google-cloud-api-deployments), you'll want to [release a new build version to your app stores](#version-bump).

## Project Wrap-Up

- Remove [test mode configuration](https://developers.google.com/admob/flutter/test-ads) for ads before submitting your app for review.
  - Note that this should be done as close to submission as possible to avoid unnecessary costs for ads engagement in your test apps.
- Finalize metadata and required fields for app store submission and review.
  - Google Play Store: `Policy --> App Content`
  - Apple App Store Connect: `General --> App Privacy --> Data Types`
- Submit your apps for review.
- Once approved, release your apps!
