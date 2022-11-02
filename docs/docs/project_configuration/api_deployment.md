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

You can also choose deploy your Dart Frog API to other services, like [AWS App Runner](https://dartfrog.vgv.dev/docs/deploy/aws-app-runner) or [Digital Ocean App Platform](https://dartfrog.vgv.dev/docs/deploy/digital-ocean-app-platform).
