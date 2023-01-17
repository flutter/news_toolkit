---
sidebar_position: 6
description: Learn how to configure authentication in your Flutter news application.
---

# Authentication

Currently, the Flutter News Toolkit project supports multiple ways of authentication such as `email`, `google`, `apple`, `twitter`, and `facebook` login.

The current implementation of the login functionality can be found in [FirebaseAuthenticationClient](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/packages/authentication_client/firebase_authentication_client/lib/src/firebase_authentication_client.dart#L20) inside the `packages/authentication_client` package.

The package depends on the third-party packages that expose authentication methods such as:

- `firebase_auth`
- `flutter_facebook_auth`
- `google_sign_in`
- `sign_in_with_apple`
- `twitter_login`

To enable authentication, configure each authentication method:

- For email login, enable the **Email/password sign-in provider** in the Firebase Console of your project. In the same section, enable the **Email link sign-in method**. On the dynamic links page, set up a new dynamic link URL prefix (for example, `yourApplicationName.page.link`) with a dynamic link URL of "/email_login".
- For Google login, enable the **Google sign-in provider** in the Firebase Console of your project. You might need to generate a `SHA1` key for use with Android.
- For Apple login, [configure sign-in with Apple](https://firebase.google.com/docs/auth/ios/apple#configure-sign-in-with-apple) in the Apple's developer portal and [enable the **Apple sign-in provider**](https://firebase.google.com/docs/auth/ios/apple#enable-apple-as-a-sign-in-provider) in the Firebase Console of your project.
- For Twitter login, register an app in the Twitter developer portal and enable the **Twitter sign-in provider** in the Firebase Console of your project.
- For Facebook login, register an app in the Facebook developer portal and enable the **Facebook sign-in provider** in the Firebase Console of your project.

Once configured, make sure to update the Firebase config file (Google services) in your application.

For more detailed information about these authentication methods, check out the [firebase.google.com](https://firebase.google.com/docs/auth/flutter/federated-auth) documentation.
