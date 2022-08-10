# Google News Template

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

## Usage

### Activate Mason

```sh
dart pub global activate mason_cli
```

### Add the Google News Template Brick

When using user/password authentication:

```sh
mason add google_news_template -g --git-url https://github.com/VGVentures/google_news_template --git-path google_news_template
```

When using ssh authentication:

```sh
mason add google_news_template -g --git-url git@github.com:VGVentures/google_news_template.git --git-path google_news_template
```

### Generate

```sh
mason make google_news_template -c template.json
```

For additional usage information and information about how to create custom templates refer to the [mason documentation](https://github.com/felangel/mason).

---

## Recommendations

### Recommended Firebase configuration

It is recommended to define at least two application environments: development and production. Each environment defines a different configuration of deep links, ads and authentication along with a different entry point to the application (e.g. `main_development.dart`).

When generating the template, choose "development production" as a list of desired application flavors. Choose "dev" as the application suffix for the development flavor.

In Firebase, configure two separate Firebase projects for the development and production flavor. You may do this [from the Firebase console](https://console.firebase.google.com/u/0/) or using the [firebase-tools CLI tool](https://github.com/firebase/firebase-tools) and the `firebase projects:create` command. In each Firebase project, create an Android and iOS app with appropriate package names. Make sure that development apps include the "dev" suffix. You may also do this using the `firebase apps:create` command.

When configured, go to each Firebase project settings and export Google Services file for all apps. In the generated template, replace the content of all generated Google Services using exported configurations.

### Recommended Github branch protection rules

The generated template includes Github workflows for the application module and all local packages to ensure that formatting, analyzing and all tests pass before merging a pull request. It is recommended to enforce branch protection rules for the main branch of your repository. 

You may choose to enable branch protection rules in Github repository settings. Below are the recommended options:
- Require a pull request before merging (require approvals, dismiss stale pull request approvals when new commits are pushed, require review from Code Owners).
- Require status checks to pass before merging (require branches to be up to date before merging).
- Require linear history.

[1]: https://github.com/felangel/mason