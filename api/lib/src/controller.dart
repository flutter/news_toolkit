import 'package:shelf/shelf.dart';

/// {@template controller}
/// A class responsible for handling incoming requests for a set of routes.
/// {@endtemplate}
abstract class Controller {
  /// {@macro controller}
  const Controller();

  /// Route handler.
  Handler get handler;
}
