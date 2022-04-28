import 'package:meta/meta.dart';

/// {@template news_block}
/// A reusable news block which represents a content-based component.
/// {@endtemplate}
@immutable
abstract class NewsBlock {
  /// {@macro news_block}
  const NewsBlock({required this.type});

  /// The block type key used to identify the type of block/metadata.
  final String type;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson();
}
