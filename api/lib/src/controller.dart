import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template controller}
/// A class responsible for handling incoming requests for a set of routes.
/// {@endtemplate}
abstract class Controller {
  /// {@macro controller}
  const Controller();

  /// Route handler.
  Handler get handler;
}

/// Extension on [Router] that supports registering a controller.
extension RegisterController on Router {
  /// Registers the provided [controller] for the route [prefix].
  void register(String prefix, Controller controller) {
    mount(prefix, controller.handler);
  }
}
