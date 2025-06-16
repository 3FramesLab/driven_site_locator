part of site_locator_module;

extension ListExtension<T> on List<T> {
  void clearAndAddAll(List<T> iterable) {
    clear();
    addAll(iterable);
  }

  bool containsIgnoreCase(String value) {
    return any(
        (element) => element.toString().toLowerCase() == value.toLowerCase());
  }
}
