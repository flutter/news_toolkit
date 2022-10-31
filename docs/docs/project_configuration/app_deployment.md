---
sidebar_position: 7
description: Learn how to setup continous deployments for your application.
---

# App Deployment Setup

## Codemagic

- Configure the ‘TODO’ fields in the codemagic.yaml file located in your repository.
- Create the [App Store API Key](https://docs.codemagic.io/yaml-code-signing/signing-ios/#creating-the-app-store-connect-api-key) and add this to your Codemagic account.
- [Generate and upload a Keystore](https://docs.codemagic.io/yaml-code-signing/signing-android/#generating-a-keystore).
- Configure the prod_emails and tst_emails in the codemagic.yaml file located in your repository.
- Set up the [GPLAY_KEY](https://docs.codemagic.io/knowledge-base/google-services-authentication/) in Codemagic.
- Encrypt the GPLAY_KEY in Codemagic .
- Set-up the [GoogleApiService account connection](https://docs.codemagic.io/knowledge-base/google-services-authentication/) in Codemagic

## Other
