part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchTermChanged extends SearchEvent {
  const SearchTermChanged({this.searchTerm = ''});

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}
