---
sidebar_position: 7
description: Learn how to setup continous deployments for your application.
---

# App Deployment Setup

## Codemagic
Codemagic is an automated CI/CD service that streamlines deployments to the Google Play Store and App Store Connect. You can configure your CI/CD pipeuline up front and trigger deployments automatically with each subsequent code change.

To leverage this service, login or [create a Codemagic account](https://codemagic.io/signup?campaign=flutter-ci-header_sign_up_btn) and follow the [getting started guide](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/) to setup your `codemagic.yaml` for build configuration on Codemagic. Be sure to populate all 'TODO' fields in your codemagic.yaml file.

For this project specifically, be sure to create an [App Store API Key](https://docs.codemagic.io/yaml-code-signing/signing-ios/#creating-the-app-store-connect-api-key) and add this to your Codemagic account. In addition, [generate an upload a keytore](https://docs.codemagic.io/yaml-code-signing/signing-android/#generating-a-keystore).

A service account is required when setting up publishing to Google Play. The service account JSON key file must be added to Codemagic to authenticate with these services. To set up a service account for authentication with Google Play and Firebase, follow the instructions [here](https://docs.codemagic.io/knowledge-base/google-services-authentication/). 

:::note

Codemagic is not a required service for this project. You're welcome to use other automated CI/CD services for your apps, if desired.

:::
