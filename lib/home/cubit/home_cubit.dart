import 'package:bloc/bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.topStories);

  void setTab(int selectedTab) {
    switch (selectedTab) {
      case 0:
        emit(HomeState.topStories);
        break;
      case 1:
        emit(HomeState.search);
        break;
      case 2:
        emit(HomeState.subscribe);
        break;
    }
  }
}
