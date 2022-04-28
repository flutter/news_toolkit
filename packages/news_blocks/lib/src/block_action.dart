import 'package:json_annotation/json_annotation.dart';

part 'block_action.g.dart';

/// The different types of actions.
enum BlockActionType {
  /// A navigation action represents an internal navigation to the provided uri.
  navigation
}

/// {@macro block_action}
/// A class which represents an action that can occur
/// when interacting with a block.
/// {@endtemplate}
@JsonSerializable()
class BlockAction {
  /// {@macro block_action}
  const BlockAction({required this.type, this.uri});

  /// Converts a `Map<String, dynamic>` into a [BlockAction] instance.
  factory BlockAction.fromJson(Map<String, dynamic> json) =>
      _$BlockActionFromJson(json);

  /// An optional uri used to determine where to route.
  final Uri? uri;

  /// The type of action;
  final BlockActionType type;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$BlockActionToJson(this);
}
