---
sidebar_position: 10
description: Learn how to configure privacy policy and terms of service in your Flutter news application.
---

# Privacy Policy & Terms of Service

Terms of service and privacy policy page information can be accessed by your users from the `UserProfilePage` or the `LoginWithEmailForm`.

You will want to replace the placeholder text displayed in the `TermsOfServiceModal` and `TermsOfServicePage` widgets with your app's privacy policy and terms of service. This can be accomplished by editing the `TermsOfServiceBody` widget found in `lib/terms_of_service/widgets/terms_of_service_body.dart`.

You can either:

- Display `WebView` widgets which link to your privacy policy and terms of service documents hosted on the web (_recommended_) or
- Pass your documents as Strings to `Text` widgets inside the `TermsOfServiceBody` widget.

In order to use the `WebView` solution, replace the `SingleChildScrollView` widget in `TermsOfServiceBody` with one or more `WebView` widgets which link to your documents. Be sure to specify `gestureRecognizers` for `WebViews` so that they are scrollable.
