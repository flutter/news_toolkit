// Taken from https://github.com/VeryGoodOpenSource/dart_frog/issues/1101

import 'package:dart_frog/dart_frog.dart';

class TestRequestContext implements RequestContext {
  TestRequestContext({
    this.path = '/',
    this.method = HttpMethod.get,
    this.headers,
  });

  String path;
  HttpMethod method;
  Map<String, String>? headers;

  final Map<String, dynamic> _dependencies = {};

  @override
  RequestContext provide<T extends Object?>(T Function() create) {
    final dependency = create();
    _dependencies[dependency.runtimeType.toString()] = dependency;
    return this;
  }

  void mockProvide<T>(T dependency) => _dependencies[T.toString()] = dependency;

  @override
  T read<T>() {
    final dependency = _dependencies[T.toString()];
    if (dependency is! T) {
      throw Error();
    }
    return dependency;
  }

  @override
  Request get request => Request(
        method.name.toUpperCase(),
        Uri.parse(path),
        headers: headers,
      );

  @override
  Map<String, String> get mountedParams => {};
}
