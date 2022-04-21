import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.anonymous] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.isNewUser = true,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// Whether the current user is a first time user.
  final bool isNewUser;

  /// Whether the current user is anonymous.
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = User(id: '');

  @override
  List<Object?> get props => [email, id, name, photo, isNewUser];
}
