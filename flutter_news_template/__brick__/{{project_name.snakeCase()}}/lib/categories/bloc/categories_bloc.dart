import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const CategoriesState.initial()) {
    on<CategoriesRequested>(_onCategoriesRequested);
    on<CategorySelected>(_onCategorySelected);
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _onCategoriesRequested(
    CategoriesRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      final response = await _newsRepository.getCategories();

      emit(
        state.copyWith(
          status: CategoriesStatus.populated,
          categories: response.categories,
          selectedCategory: response.categories.firstOrNull,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: CategoriesStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<CategoriesState> emit,
  ) =>
      emit(state.copyWith(selectedCategory: event.category));
}
