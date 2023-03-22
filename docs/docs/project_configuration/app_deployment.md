---
sidebar_position: 7
description: Learn how to setup continous deployments for your application.
---

# App deployment setup

## Codemagic

:::note

Codemagic is not a required service for this project. You're welcome to use other automated CI/CD services for your apps, if desired.

:::

Codemagic is an automated CI/CD service that streamlines deployments to the Google Play Store and App Store Connect. You can configure your CI/CD pipeline up front and trigger deployments automatically with each subsequent code change.

To use this service, login or [create a Codemagic account](https://codemagic.io/signup?campaign=flutter-ci-header_sign_up_btn) and follow the [getting started guide](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/) guide to set up a `codemagic.yaml` build configuration file. Be sure to populate all 'TODO' fields in your `codemagic.yaml` file.

For this project, specifically, be sure to create an [App Store API Key](https://docs.codemagic.io/yaml-code-signing/signing-ios/#creating-the-app-store-connect-api-key) and add this to your Codemagic account. In addition, [generate a keytore](https://docs.codemagic.io/yaml-code-signing/signing-android/#generating-a-keystore) for signing your release builds.

A service account is required when publishing to Google Play. The service account JSON key file must be added to Codemagic to authenticate with these services. To set up a service account for authentication with Google Play and Firebase, use the instructions at [Google services authetication](https://docs.codemagic.io/knowledge-base/google-services-authentication/).
