# Google News Template API ☁️

## Getting Started 🚀

Google News Template API is written in [Dart](https://dart.dev) and can be run standalone or via [Docker](https://www.docker.com).

### Running Locally ☁️💻

To run the server locally, run the following command from the current directory:

```sh
$ dart bin/server.dart
```

This will start the server on [localhost:8080](http://localhost:8080).

## API Documentation 📚

The API documentation can be found in `docs/api.apib`. The documentation uses the [API Blueprint](https://github.com/apiaryio/api-blueprint) specification and can be previewed using the [Apiary Client](https://github.com/apiaryio/apiary-client).

### Running the Documentation Locally 📚💻

To run the interactive API documentation locally make sure you have the [Apiary Client](https://github.com/apiaryio/apiary-client) installed:

```sh
$ gem install apiaryio
```

Then use the `preview` command to run the documentation:

```sh
$ apiary preview --path docs/api.apib --watch
```

The interactive documentation will be available at [localhost:8080](http://localhost:8080).

Refer to the [Apiary Client Documentation](https://help.apiary.io/tools/apiary-cli) for more information.

### Contributing to the API Documentation 🖊️📚

Refer to [APIBlueprint.org](https://apiblueprint.org) for documentation and tutorials on using the API Blueprint Specification.

Refer to the [API Blueprint Specification](https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md) for more information.

It is recommended to install the [API Elements VSCode Extension](https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements) to provide syntax highlighting and show errors/warnings when using invalid syntax.
