---
slug: /
sidebar_position: 1
---

# Overview

Flutter and the [Google News Initiative](https://newsinitiative.withgoogle.com/) have co-sponsored the development of a news application template. The goal of this project is to help news publishers build mobile applications easily in order to make reliable information accessible to all.

This template aims to **significantly reduce the development time for typical news applications** by giving developers a head start on core components and features.

The Flutter News Toolkit:

- Contains common news app UI workflows and core features built with Flutter and Firebase
- Implements best practices for news apps based on [Google News Initiative research](https://newsinitiative.withgoogle.com/info/assets/static/docs/nci/nci-playbook-en.pdf)
- Allows publishers to monetize immediately with ads and subscription services

Common services such as authentication, notifications, analytics, and ads have been implemented using [Firebase](https://firebase.flutter.dev/docs/overview/) and [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads). Developers are free to substitute these services and can find publicly available packages on [pub.dev](https://pub.dev).

If you're just getting started with Flutter, we recommend first developing familiarity with the framework by reviewing the [onboarding guides](https://docs.flutter.dev/get-started/install), [tutorials](https://docs.flutter.dev/reference/tutorials), and [codelabs](https://docs.flutter.dev/codelabs) before using this template.

:::note
Depending on the number of flavors you plan to create for your project, the setup time may vary. For example, you can complete end-to-end setup in less than 10 minutes for one flavor. For additional flavors, you can expect this setup time to increase. Check out flutter.dev/news for additional information and video tutorials.
:::

## Getting Started

### Prerequisites

**Dart**

In order to generate a project using the news template, you must have the [Dart SDK][dart_installation_link] installed on your machine.

:::info
Dart `">=3.0.0 <4.0.0"` is required.
:::

**Mason**

In addition, make sure you have installed the latest version of [mason_cli][mason_cli_link].

```bash
dart pub global activate mason_cli
```

:::info
[Mason][mason_link] is a command-line tool that allows you to generate a customized codebase based on your specifications.

You'll use mason to generate your customized news application from the Flutter News Template.
:::

**Dart Frog**

Lastly, make sure you have the latest version of [dart_frog_cli][dart_frog_cli_link] installed.

```bash
dart pub global activate dart_frog_cli
```

:::info
[Dart Frog][dart_frog_link] is a fast, minimalistic backend framework for Dart. It is stable as of [v0.1.0](https://github.com/VeryGoodOpenSource/dart_frog/releases/tag/dart_frog-v0.1.0).

You'll use Dart Frog as a [backend for frontends (BFF)](https://learn.microsoft.com/en-us/azure/architecture/patterns/backends-for-frontends), which allows you to connect your existing backend to the Flutter News Template frontend. Dart Frog reduces the barrier for entry for all publishers, despite any existing backend, and brings your app to market faster without required client modifications.

:::

### Generate your project

To generate your app using Mason, follow the steps below:

:::note
Projects generated from the Flutter News Template will use the latest stable version of Flutter.
:::

#### Install the Flutter News Template

Use the `mason add` command to install the [Flutter News Template](https://brickhub.dev/bricks/flutter_news_template) globally on your machine:

:::info
You only need to install the `flutter_news_template` once. You can generate multiple projects from the template after it's installed.

You can verify whether you have the `flutter_news_template` installed by using the `mason list --global` command.
:::

```bash
mason add -g flutter_news_template
```

#### Generate the app

Use the `mason make` command to generate your new app from the Flutter News Template:

```bash
mason make flutter_news_template
```

:::info

Running `mason make` will generate over 900 files that will be listed in the console.

You may need to increase your console scrollback buffer size to see all of the files listed in your console.

:::

#### Template configuration

You'll be prompted with several questions. Be prepared to provide the following information in order to generate your project:

```bash
# The name of your application as displayed on the device for end users.
? What is the user-facing application name? (Flutter News Template)

# The application identifier also know as the bundle identifier on iOS.
? What is the application bundle identifier? (com.flutter.news.template)

# A list of GitHub usernames who will be code owners on the repository.
# See https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
? Who are the code owners? (separated by spaces) (@githubUser)

# Select all flavors that you want the generated application to include.
# We recommend having at least development and production flavors.
# For more information see https://docs.flutter.dev/deployment/flavors
? What flavors do you want your application to include?
❯ ◉  development
  ◯  integration
  ◯  staging
  ◉  production
```

After answering the above questions, your custom news application is generated. You are now ready to run the application locally!

#### Configure Firebase

:::caution

Before you can run your generated app, you must configure Firebase.
Please follow the instructions specified in the [Firebase setup](/project_configuration/firebase) section.

:::

#### Configure or remove ads

:::info
Your project includes sample configurations for ads so that you can run your generated app with minimal setup. You will need to follow additional steps to [configure or remove ads](/project_configuration/ads).
:::

### Run the API Server

Before running the Flutter application, run the API server locally. Change directories into the `api` directory of the newly-generated project and start the development server:

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
  --target lib/main/main_development.dart \
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

## Contributions

We invite contributions from the Flutter community. Please review the [Contributing to Flutter](https://github.com/flutter/flutter/blob/master/CONTRIBUTING.md) documentation and [Contributor access](https://github.com/flutter/flutter/wiki/Contributor-access) page on our wiki to get started.

## Opening issues

Please open an issue in the main [flutter/flutter](https://github.com/flutter/flutter/issues) issue tracker if you encounter any bugs or have enhancement suggestions for this toolkit. Issues should follow the [Issue hygiene](https://github.com/flutter/flutter/wiki/Issue-hygiene) guidelines and will be [triaged](https://github.com/flutter/flutter/wiki/Triage) by the Flutter team with the appropriate labels and priority.
