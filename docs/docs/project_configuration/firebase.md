---
sidebar_position: 2
description: Learn how to configure your Firebase project.
---

# Firebase setup

You must specify Firebase configuration information for your app flavors and platforms. Please use the following instructions to create your own Firebase projects and configure your apps.

:::note

Although the Flutter News Toolkit is pre-configured to work with Firebase, you're welcome to customize your codebase to leverage other services in your project.

:::

We recommend that you define at least two application environments (also known as flavors): _development_ and _production_. Each environment defines a different configuration of deep links, ads, and authentication, along with a different entry point to the application (such as `main_development.dart`).

By default, your codebase should support a production and development flavor. However, you might have created additional flavors when generating your project from mason.

Before you can run your generated app, you must configure Firebase.

:::note

The [flutterfire-cli](https://firebase.google.com/docs/flutter/setup#configure-firebase) doesn't yet [support multiple flavors](https://github.com/invertase/flutterfire_cli/issues/14).

Since your project supports multiple flavors, you must manually configure Firebase.

:::

Go to the [Firebase Console](https://console.firebase.google.com), sign in with your Google account, and create a separate Firebase project for each flavor that your project supports (such as development and production).

In each Firebase project, create an Android and iOS app with the corresponding application IDs. Make sure that the application ID includes the correct suffix (such as "dev" for the development flavor).

Download the Google Services file for each app from the **Project Settings** page in the Firebase Console. Then, go to the source code of your generated app and look for the following `TODOs` for each flavor:

**Android**

```
// Replace with google-services.json from the Firebase Console //
```

**iOS**

```
<!-- Replace with GoogleService-Info.plist from the Firebase Console -->
```

Replace this message (for every flavor of the app) with the contents of the `google-services.json` and `GoogleServiceInfo.plist` files that you just downloaded from the Firebase Console.

Lastly, for iOS only, you must open `ios/Runner.xcodeproj/project.pbxproj` and replace the following placeholder with the corresponding `reversed_client_id` from the `GoogleServiceInfo.plist` file:

```
REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
```

When searching for this placeholder, the number of results will depend on the number of flavors configured for your project. For each flavor configured, there will be 2 configuration sections (`debug` and `release`).

For example, if you set up `development` and `production` as your project's flavors, you will find the following configuration sections:

- **Debug-development** (build development flavor in debug mode)
- **Release-development** (build development flavor in release mode)
- **Debug-production** (build production flavor in debug mode)
- **Release-production** (build production flavor in release mode)

Your `ios/Runner.xcodeproj/project.pbxproj` should have the following format:

```bash
/* Begin XCBuildConfiguration section */

# Release-production
0CMNTMSTYJKWAP508TXPJJN5 /* Release-production */ = {
...
buildSettings = {
  ...
  REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
  ...
};
name = "Release-production";
};
                ...

# Debug-development
1ON144SZQH163C0TE8AP2QLM /* Debug-development */ = {
  ...
  buildSettings = {
    ...
    REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
    ...
  };
  name = "Debug-development";
};
                ...

# Release-development
53ZSJWL4HHR1DK5C45O2YEZ5 /* Release-development */ = {
  ...
  buildSettings = {
    ...
    REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
    ...
  };
  name = "Release-development";
};
                ...

# Debug-production
HLDEZL79XQNUTPT4UM4UEEL7 /* Debug-production */ = {
  ...
  buildSettings = {
    ...
    REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
    ...
  };
 name = "Debug-production";
};
                ...

/* End XCBuildConfiguration section */
```

If your `GoogleServiceInfo.plist` for the development flavor looks like:

```
<plist version="1.0">
<dict>
	...
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.737894073936-ccvknt0jpr1nk3uhftg14k8duirosg9t</string>
  ...
</dict>
</plist>
```

then in `ios/Runner.xcodeproj/project.pbxproj` you must replace the `reversed_client_id` inside the **Debug-development** and **Release-development** configuration sections.

This process must also be repeated with the `GoogleServiceInfo.plist` of the other existing flavors on your app (e.g _production_), inside the respective configuration sections of the `project.pbxproj` file.
