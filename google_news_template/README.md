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

[1]: https://github.com/felangel/mason