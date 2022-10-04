import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.topStories);

  void setTab(int selectedTab) {
    switch (selectedTab) {
      case 0:
        FocusManager.instance.primaryFocus?.unfocus();
        return emit(HomeState.topStories);
      case 1:
        return emit(HomeState.search);
      case 2:
        return emit(HomeState.subscribe);
    }
  }
}
