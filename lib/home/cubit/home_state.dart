part of 'home_cubit.dart';

enum HomeState {
  topStories(0),
  search(1),
  subscribe(2);

  const HomeState(this.tabIndex);
  final int tabIndex;
}
