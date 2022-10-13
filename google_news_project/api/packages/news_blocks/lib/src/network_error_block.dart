import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'network_error_block.g.dart';

/// {@template spacer_block}
/// A block which represents a spacer.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=358%3A18765
/// {@endtemplate}
@JsonSerializable()
class NetworkErrorBlock with EquatableMixin implements NewsBlock {
  /// {@macro network_error_block}
  const NetworkErrorBlock({this.type = NetworkErrorBlock.identifier});

  /// Converts a `Map<String, dynamic>` into a [NetworkErrorBlock] instance.
  factory NetworkErrorBlock.fromJson(Map<String, dynamic> json) =>
      _$NetworkErrorBlockFromJson(json);

  /// The spacer block type identifier.
  static const identifier = '__network_error__';

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$NetworkErrorBlockToJson(this);

  @override
  List<Object?> get props => [type];
}
