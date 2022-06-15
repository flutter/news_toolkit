part of 'article_bloc.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class ArticleRequested extends ArticleEvent {
  const ArticleRequested();
}

class ArticleRewardedAdWatched extends ArticleEvent {
  const ArticleRewardedAdWatched();
}

class ShareRequested extends ArticleEvent {
  const ShareRequested({required this.uri});

  final Uri uri;

  @override
  List<Object> get props => [uri];
}
