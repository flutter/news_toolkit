import 'package:shelf/shelf.dart';

/// Extension on [Pipeline] which adds support
/// for injecting values into the request context.
extension PipelineInjection on Pipeline {
  /// Inject a [value] into the pipeline.
  Pipeline inject<T extends Object>(T value) {
    return addMiddleware((innerHandler) {
      return (request) {
        return innerHandler(
          request.change(context: {...request.context, T.toString(): value}),
        );
      };
    });
  }
}

/// Extension on [Request] which adds support
/// for accessing values from the request context.
extension GetRequest on Request {
  /// Lookup an instance of [T] from context.
  T get<T>() => context[T.toString()] as T;
}
