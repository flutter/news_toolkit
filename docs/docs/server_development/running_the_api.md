---
sidebar_position: 1
description: Learn how to run your news API.
---

# Running the API

## Overview

The Flutter News Example API is written in [Dart](https://dart.dev) and uses [Dart Frog](https://dartfrog.vgv.dev).

### Running the API server locally

To launch the server locally, run the following command from the current directory:

```sh
dart_frog dev
```

This starts the server on [localhost:8080](http://localhost:8080).

### Running the API server in Docker

To run the server in Docker, make sure you have [Docker installed](https://docs.docker.com/get-docker/), then use the following instructions:

1. Create a production build with the following command:

```sh
dart_frog build
```

2. Switch directories into the generated `build` directory:

```sh
cd build
```

3. Create a Docker image:

```sh
docker build -q .
```

Once you have created an image, run it using the following command:

```sh
docker run -d -p 8080:8080 --rm <IMAGE>
```

To kill the container:

```sh
docker kill <CONTAINER>
```

To delete an image:

```sh
docker rmi <IMAGE>
```

## API documentation

Find the service API documentation in `docs/api.apib`. The documentation uses the [API Blueprint](https://github.com/apiaryio/api-blueprint) specification. Preview the doc using the [Apiary Client](https://github.com/apiaryio/apiary-client).

### Running the documentation locally

To run the interactive API documentation locally, make sure that you have the [Apiary Client](https://github.com/apiaryio/apiary-client) installed:

```sh
$ gem install apiaryio
```

Then use the `preview` command to run the documentation:

```sh
$ apiary preview --path docs/api.apib --watch
```

The interactive documentation is available at [localhost:8080](http://localhost:8080).

For more information, refer to the [Apiary Client Documentation](https://help.apiary.io/tools/apiary-cli).

### Contributing to the API documentation

For documentation and tutorials on using the API Blueprint specification, refer to [APIBlueprint.org](https://apiblueprint.org/).

For more information, refer to the [API Blueprint Specification](https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md).

We recommend that you install the [API Elements VSCode Extension](https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements) to provide syntax highlighting and show errors and warnings when using invalid syntax.
