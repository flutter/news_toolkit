---
sidebar_position: 11
description: Learn how to configure privacy policy and terms of service in your Flutter news application.
---

# Privacy policy & terms of service

Your users access the terms of service and privacy policy page information from the `UserProfilePage` or the `LoginWithEmailForm`.

Replace the placeholder text displayed in the `TermsOfServiceModal` and `TermsOfServicePage` widgets with your app's privacy policy and terms of service by editing the `TermsOfServiceBody` widget (`lib/terms_of_service/widgets/terms_of_service_body.dart`).

You can do one of the following:

- Display `WebView` widgets that link to your privacy policy and terms of service documents hosted on the web (_recommended_).
- Pass your documents as strings to the `Text` widgets inside the `TermsOfServiceBody` widget.

To use the `WebView` solution, replace the `SingleChildScrollView` widget in `TermsOfServiceBody` with one or more `WebView` widgets that link to your documents. Be sure to specify `gestureRecognizers` for `WebViews` so that they are scrollable.
