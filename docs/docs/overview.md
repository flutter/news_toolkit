---
slug: /
sidebar_position: 1
---

# Overview

The Google Flutter team and Google News Initiative have co-sponsored the development of a news application template. Our goal is to help news publishers to build apps and monetize more easily than ever.

This template aims to reduce typical news app development time by 80%.

The Flutter news app template:

- Contains common news app UI workflows and core features built in Flutter and Firebase
- Implements best practices for news apps based on Google News Initiative research
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
[Mason][mason_link] is a command line application which allows you to generate a customized codebase based on your specifications.
:::

**Dart Frog**

Lastly, make sure you have the latest version of [dart_frog_cli][dart_frog_cli_link] installed.

```bash
dart pub global activate dart_frog_cli
```

:::info
[Dart Frog][dart_frog_link] is fast, minimalistic backend framework for Dart.
:::

### Generate your project

To generate your app using Mason, follow the steps below:

#### Install the Flutter News Template

Use the `mason add` command to install the Flutter News Template globally on your machine:

**via https:**

```bash
mason add -g flutter_news_template --git-url https://github.com/flutter/news_toolkit --git-path flutter_news_template
```

**via ssh**

```bash
mason add -g flutter_news_template --git-url git@github.com:flutter/news_toolkit.git --git-path flutter_news_template
```

#### Generate the project

Use the `mason make` command to generate your new project from the template:

```bash
mason make flutter_news_template
```

#### Run the Flutter app

You should now be able to change directories into your newly generated project and run the project in development mode:

```bash
flutter run --flavor development --target lib/main/main_development.dart
```

#### Run the API Server

To run the news API server, change directories into the `api` directory of the newly generated project and start the development server:

```bash
dart_frog dev
```

## Template Features

This template includes typical features that a news application requires out of the box and is fully customizable to meet your needs.

- Core
  - Ready-to-go core services
  - User authentication
  - Push notifications
  - App tracking
  - Content feed
- News features
  - Content feed
    - Pull to refresh
    - Subscriptions and purchases
    - Newsletter subscription
  - Article pages
    - In-line images
    - Image slideshow
    - Video player
    - Comment section
  - Ads
  - Search

[dart_frog_cli_link]: https://pub.dev/packages/dart_frog_cli
[dart_frog_link]: https://dartfrog.vgv.dev
[dart_installation_link]: https://dart.dev/get-dart
[mason_link]: https://github.com/felangel/mason
[mason_cli_link]: https://pub.dev/packages/mason_cli
