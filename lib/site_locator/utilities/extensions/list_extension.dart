extension ListExtension<T> on List<T> {
  void clearAndAddAll(List<T> iterable) {
    clear();
    addAll(iterable);
  }
}
