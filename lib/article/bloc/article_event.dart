part of 'article_bloc.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();
}

class ArticleRequested extends ArticleEvent {
  const ArticleRequested({
    required this.id,
  });

  /// The id of the requested article.
  final String id;

  @override
  List<Object> get props => [id];
}
