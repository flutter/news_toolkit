import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_repository/news_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';
part 'categories_bloc.g.dart';

class CategoriesBloc extends HydratedBloc<CategoriesEvent, CategoriesState> {
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

  @override
  CategoriesState? fromJson(Map<String, dynamic> json) =>
      CategoriesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CategoriesState state) => state.toJson();
}
