part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class PopularSearchRequested extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class SearchTermChanged extends SearchEvent {
  const SearchTermChanged({required this.searchTerm});

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}
