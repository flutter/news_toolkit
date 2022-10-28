---
sidebar_position: 1
description: Learn how to run your news application.
---

# Running the App

The news application project contains 2 flavors:

- development
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

# Development

```bash
flutter run --flavor development --target lib/main_development.dart
```

# Production

```bash
flutter run --flavor production --target lib/main_production.dart
```

:::note
Google News Template works on iOS and Android.
:::
