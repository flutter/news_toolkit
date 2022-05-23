part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class LoadPopular extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class KeywordChanged extends SearchEvent {
  const KeywordChanged({required this.keyword});

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}
