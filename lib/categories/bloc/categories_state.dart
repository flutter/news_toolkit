part of 'categories_bloc.dart';

enum CategoriesStatus {
  initial,
  loading,
  populated,
  failure,
}

class CategoriesState extends Equatable {
  const CategoriesState({
    required this.status,
    this.categories,
  });

  const CategoriesState.initial()
      : this(
          status: CategoriesStatus.initial,
        );

  final CategoriesStatus status;
  final List<Category>? categories;

  @override
  List<Object?> get props => [
        status,
        categories,
      ];

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<Category>? categories,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}
