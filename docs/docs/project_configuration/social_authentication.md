---
sidebar_position: 2
description: Learn how to configure social login with Facebook and Twitter.
---

# Social Authentication Setup

## Facebook

- Create an app in the [Facebook developer portal](https://developers.facebook.com/apps/).
- In the same portal, enable the Facebook Login product (`Products -> Facebook Login`).
- Go to `Roles -> Roles` and add your developer team so the team can customize the agpp configuration for Android and iOS.
- In Facebook, go to `Settings -> Advanced` and enable "App authentication, Native or desktop app?"
- After setting up your [Firebase project](#firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Facebook` to set up Facebook authentication method. Fill in the app ID and secret from the created Facebook app and share these secrets with your developer team.
- Use "OAuth redirect URI" from Firebase to set "Valid Oauth Redirect URIs" in the Facebook portal.

## Twitter

- Create a project and app in the [Twitter developer portal](https://developer.twitter.com/) - both can have the same name. Save the API key and secret when creating an app and share these secrets with your developer team.
- Enable OAuth 2.0 authentication by setting "yourapp://" as the callback URI and "Native app" as the type of the app.
- In [Twitter products](https://developer.twitter.com/en/portal/products), make sure to have the Twitter API v2 enabled with "Elevated" access - otherwise Twitter authentication is not going to work.
  - You may need to fill out a form to apply for “Elevated” access.
- If possible, add your full team as developers of the Twitter app.
- After setting up your [Firebase project](#firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Twitter` to set up Twitter authentication method. Fill in the app ID and secret from the created Twitter app and share these secrets with your developer team.
