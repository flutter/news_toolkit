---
slug: /
sidebar_position: 1
---

# Overview

The Google Flutter team and Google News Initiative have co-sponsored the development of a news application template. Our goal is to help news publishers to build apps and monetize more easily than ever in order to make reliable information accessible to all.

This template aims to **reduce the time to develop a typical news app by 80%**.

The Flutter News Toolkit:

- Contains common news app UI workflows and core features built with Flutter and Firebase
- Implements best practices for news apps based on [Google News Initiative research](https://newsinitiative.withgoogle.com/info/assets/static/docs/nci/nci-playbook-en.pdf)
- Allows publishers to monetize immediately with pre-built Google Ads and subscription services

## Quick Start

### Prerequisites

**Dart**

In order to generate a project using the news template, you must have the [Dart SDK][dart_installation_link] installed on your machine.

:::info
Dart `">=2.18.0 <3.0.0"` is required.
:::

**Mason**

In addition, make sure you have installed the latest version of [mason_cli][mason_cli_link].

```bash
dart pub global activate mason_cli
```

:::info
[Mason][mason_link] is a command-line tool which allows you to generate a customized codebase based on your specifications.

We'll use mason to generate your customized news application from the Flutter News Template.
:::

**Dart Frog**

Lastly, make sure you have the latest version of [dart_frog_cli][dart_frog_cli_link] installed.

```bash
dart pub global activate dart_frog_cli
```

:::info
[Dart Frog][dart_frog_link] is fast, minimalistic backend framework for Dart.

We'll use Dart Frog as a backend for frontends (BFF) which will allow you to connect your backend with the Flutter News Template frontend.
:::

### Generate your project

To generate your app using Mason, follow the steps below:

:::note
Projects generated from the Flutter News Template will use the latest stable version of Flutter.
:::

#### Install the Flutter News Template

Use the `mason add` command to install the Flutter News Template globally on your machine:

:::info
You only need to install the `flutter_news_template` the first time. You can generate multiple projects from the template after it is installed.

You can verify whether or not you have the `flutter_news_template` installed by using the `mason list --global` command.
:::

**via https:**

```bash
mason add -g flutter_news_template --git-url https://github.com/flutter/news_toolkit --git-ref templates --git-path flutter_news_template
```

**via ssh**

```bash
mason add -g flutter_news_template --git-url git@github.com:flutter/news_toolkit.git --git-ref templates --git-path flutter_news_template
```

#### Generate the app

Use the `mason make` command to generate your new app from the Flutter News Template:

```bash
mason make flutter_news_template
```

#### Template Configuration

You'll be prompted with the following questions. Be prepared to provide the following information in order to generate your project:

```bash
# The name of your application as displayed on the device for end users.
? What is the user-facing application name? (Flutter News Template)

# The name of your application's package in the pubspec.yaml (developer facing name).
# This must follow dart package naming conventions: https://dart.dev/tools/pub/pubspec#name
? What is the application package name? (flutter_news_template)

# The application identifier also know as the bundle identifier on iOS.
? What is the application bundle identifier? (com.flutter.news.template)

# A list of GitHub usernames who will be code owners on the repository.
# See https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
? Who are the code owners? (separated by spaces) (@githubUser)

# Select all flavors which you want the generated application to include.
# We recommend having at least development and production flavors.
# For more information see https://docs.flutter.dev/deployment/flavors
? What flavors do you want your application to include?
❯ ◉  development
  ◯  integration
  ◯  staging
  ◉  production
```

After answering the above questions, your custom news application will be generated. You are now ready to run the application locally!

:::caution

Your project does not contain functional placeholder Firebase configuration information. You will need to follow the additional configuration steps for Firebase and ads setup:

- [Configure Firebase](/project_configuration/firebase)
  - [Configure Social Authentication with Firebase](/project_configuration/social_authentication)
- [Configure or Remove Ads](/project_configuration/ads)

:::

### Run the API Server

Before running the Flutter application, we need to run the API server locally. Change directories into the `api` directory of the newly-generated project and start the development server:

```bash
dart_frog dev
```

### Run the Flutter app

We recommend running the project directly from [VS Code](https://code.visualstudio.com) or [Android Studio](https://developer.android.com/studio).

:::info
You can also run the project directly from the command-line using the following command from the root project directory:

```bash
flutter run \
  --flavor development \
  --target lib/main/main_development \
  --dart-define FLAVOR_DEEP_LINK_DOMAIN=<YOUR-DEEP-LINK-DOMAIN> \
  --dart-define FLAVOR_DEEP_LINK_PATH=<YOUR-DEEP-LINK-PATH> \
  --dart-define TWITTER_API_KEY=<YOUR-TWITTER-API-KEY> \
  --dart-define TWITTER_API_SECRET=<YOUR-TWITTER-API-SECRET> \
  --dart-define TWITTER_REDIRECT_URI=<YOUR-TWITTER-REDIRECT-URI>
```

:::

Congrats 🎉

You've generated and run your custom news app! Head over to [project configuration](/category/project-configuration) for next steps.

[dart_frog_cli_link]: https://pub.dev/packages/dart_frog_cli
[dart_frog_link]: https://dartfrog.vgv.dev
[dart_installation_link]: https://dart.dev/get-dart
[mason_link]: https://github.com/felangel/mason
[mason_cli_link]: https://pub.dev/packages/mason_cli
