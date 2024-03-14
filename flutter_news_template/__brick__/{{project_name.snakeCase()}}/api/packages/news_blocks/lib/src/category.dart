/// The supported news category types.
enum Category {
  /// News relating to business.
  business,

  /// News relating to entertainment.
  entertainment,

  /// Breaking news.
  top,

  /// News relating to health.
  health,

  /// News relating to science.
  science,

  /// News relating to sports.
  sports,

  /// News relating to technology.
  technology;

  /// Returns a [Category] for the [categoryName].
  static Category fromString(String categoryName) =>
      Category.values.firstWhere((category) => category.name == categoryName);
}
