# {{app_name}} API ☁️

## Getting Started 🚀

The {{app_name}} API is written in [Dart](https://dart.dev) and uses [Dart Frog](https://verygoodopensource.github.io/dart_frog).

### Running Server Locally ☁️💻

To run the server locally, run the following command from the current directory:

```sh
dart_frog dev
```

This will start the server on [localhost:8080](http://localhost:8080).

### Running in Docker 🐳

To run the server in Docker, make sure you have [Docker installed](https://docs.docker.com/get-docker/).

First, create a production build via:

```sh
dart_frog build
```

Next, switch directories into the generated `build` directory.

```sh
cd build
```

Then you can create an image:

```sh
docker build -q .
```

Once you have created an image, you can run the image via:

```sh
docker run -d -p 8080:8080 --rm <IMAGE>
```

To kill the container:

```sh
docker kill <CONTAINER>
```

If you wish to delete an image you can run:

```sh
docker rmi <IMAGE>
```

## API Documentation 📚

The service API documentation can be found in `docs/api.apib`. The documentation uses the [API Blueprint](https://github.com/apiaryio/api-blueprint) specification and can be previewed using the [Apiary Client](https://github.com/apiaryio/apiary-client).

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

Refer to [APIBlueprint.org](https://apiblueprint.org/) for documentation and tutorials on using the API Blueprint Specification.

Refer to the [API Blueprint Specification](https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md) for more information.

It is recommended to install the [API Elements VSCode Extension](https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements) to provide syntax highlighting and show errors/warnings when using invalid syntax.
