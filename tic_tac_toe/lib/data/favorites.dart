class FavoriteRecipes {
  static final List<Map<String, dynamic>> _favorites = [];

  static List<Map<String, dynamic>> get all => _favorites;

  static void add(Map<String, dynamic> recipe) {
    _favorites.add(recipe);
  }

  static void remove(String title) {
    _favorites.removeWhere((item) => item['title'] == title);
  }

  static bool contains(String title) {
    return _favorites.any((item) => item['title'] == title);
  }

  // ⚡ Добавляем метод для обновления всего списка
  static void setAll(List<Map<String, dynamic>> recipes) {
    _favorites
      ..clear()
      ..addAll(recipes);
  }
}
