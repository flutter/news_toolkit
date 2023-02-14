---
sidebar_position: 8
description: Learn how to setup continous deployments for your API.
---

# API deployment setup

The Flutter News Toolkit uses [Dart Frog](https://dartfrog.vgv.dev/docs/overview) to simplify the backend build by aggregating, composing, and normalizing data from multiple sources. You must deploy your Dart Frog API to serve requests to the internet.

## Google Cloud

You can deploy your Dart Frog API to [Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run), a managed compute platform that lets you run containers directly on top of Google's scalable infrustructure. To deploy your API to Cloud Run, check out the Dart Frog instructions at [Google Cloud Run](https://dartfrog.vgv.dev/docs/deploy/google-cloud-run) and review the details below. Also, set up a [GitHub Action Service Account](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions) to ease the process of authenticating and authorizing GitHub Actions Workflows to Google Cloud.

### Deployment Steps

If you've created a development and production flavor for your application, you'll want two corresponding Google Cloud Projects where the API must be deployed:

- **Development:**

  - project_id: example-name-dev

  - service_name : example-name-api-dev

- **Production:**

  - project_id: example-name-prod

  - service_name : example-name-api-prod

Every time a change is made inside the API, a new version must be deployed to Cloud Run for both GCP projects. To do so, follow the steps below:

1. Make sure you have the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured.
2. Make sure you have the [Dart SDK](https://dart.dev/get-dart) and the [Dart Frog](https://pub.dev/packages/dart_frog) packages installed and configured.
3. Login into the GCP account using the `gcloud auth login` command, selecting the email account that has access to your project's GCP accounts.
4. Run the `gcloud config set project <project_id>` command to set the project to be one of the app's projects.
5. Open a terminal inside the `api` folder, and run the `dart_frog build` command. This will create a `/build` directory with all the files needed to deploy the API.
6. Run the following command to deploy the API to Cloud Run:

   ```bash
   gcloud run deploy [service_name]  \

   --source build \

   --project=[project_id] \

   --region=us-central \

   --allow-unauthenticated
   ```

   _Note: the `--allow-unauthenticated` is needed because the api can be publicly accessed._

7. If the deploy was made to the already existing service (by using the `service_name` values provided above), the URL will be the same as the previous version. Otherwise, it must be updated as `API_BASE_URL` inside the `launch.json` file of the project.

:::note

You can optionally configure [API authentication](https://cloud.google.com/docs/authentication) and [user authentication for your API](https://cloud.google.com/run/docs/authenticating/end-users#cicp-firebase-auth), if desired.

:::

## Other

You can also deploy your Dart Frog API to other services, like [AWS App Runner](https://dartfrog.vgv.dev/docs/deploy/aws-app-runner) or [Digital Ocean App Platform](https://dartfrog.vgv.dev/docs/deploy/digital-ocean-app-platform).

## Accessing your API

By default, your app expects to receive news data from `localhost`. In order to receive data from your deployed API, you must point your app towards your new URL.

:::note

If you're using an android emulator, you must set `https://10.0.2.2:8080` as the `baseUrl` instead of `http://localhost:8080`.

:::

Create a new `ApiClient` class that extends `FlutterNewsExampleApiClient` and set the `baseUrl` field to your new API URL. Additionally, override any `FlutterNewsExampleApiClient` methods which diverge from your API request schema, and implement them to handle the request appropriately.

Finally, edit the `main_flavor.dart` file for every app flavor you want receiving data from your deployed API. Remove the assignment of `apiClient` to `FlutterNewsExampleApiClient.localhost` and assign `apiClient` to an instance of your new API client. For example:

```dart
final apiClient = YourNewsApiClient(
    tokenProvider: tokenStorage.readToken,
    baseURL: 'https://yourApiBaseURL',
);
```
