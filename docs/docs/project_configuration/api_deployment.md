---
sidebar_position: 8
description: Learn how to setup continous deployments for your API.
---

# API Deployment Setup

The Flutter News Toolkit leverages [Dart Frog](https://dartfrog.vgv.dev/docs/overview) to simplify backend build by aggregating, composing, and normalizing data from multiple sources. You must deploy your Dart Frog API to serve requests to the internet.

## Google Cloud

You can choose to deploy your Dart Frog API to [Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run), a managed compute platform that lets you run containers directly on top of Google's scalable infrustructure. Learn how to deploy your API to Cloud Run by following the intructions [here](https://dartfrog.vgv.dev/docs/deploy/google-cloud-run). You'll also want to setup a [GitHub Action Service Account](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions) to ease the process of authenticating and authorizing GitHub Actions Workflows to Google Cloud.

:::note

You can optionally configure [API authentication](https://cloud.google.com/docs/authentication) and [user authentication for your API](https://cloud.google.com/run/docs/authenticating/end-users#cicp-firebase-auth), if desired.

:::

## Other

You can also choose to deploy your Dart Frog API to other services, like [AWS App Runner](https://dartfrog.vgv.dev/docs/deploy/aws-app-runner) or [Digital Ocean App Platform](https://dartfrog.vgv.dev/docs/deploy/digital-ocean-app-platform).

## Accessing Your API

By default your app expects to receive news data from `localhost`. In order to receive data from your deployed API, you must point your app towards your new URL.

:::note

If you are using an android emulator, you must set `https://10.0.2.2:8080` as the `_baseURl` instead of `http://localhost:8080`.

:::

Create a new `ApiClient` class which extends `FlutterNewsExampleApiClient` and set the `_baseURl` field to your new API URL. Additionally, override any `FlutterNewsExampleApiClient` methods which diverge from your API request schema, and implement them to handle the request appropriately.

Finally, edit the `main_flavor.dart` file for every app flavor you want receiving data from your deployed API. Remove the assignment of `apiClient` to `FlutterNewsExampleApiClient.localhost` and assign `apiClient` to an instance of your new API client:

```dart
final apiClient = YourNewsApiClient(
    tokenProvider: tokenStorage.readToken,
    baseURL: 'https://yourApiBaseURL',
);
```
