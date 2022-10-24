part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
}

class CategoriesRequested extends CategoriesEvent {
  const CategoriesRequested();

  @override
  List<Object> get props => [];
}

class CategorySelected extends CategoriesEvent {
  const CategorySelected({required this.category});

  final Category category;

  @override
  List<Object> get props => [category];
}
