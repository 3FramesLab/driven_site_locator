class SiteFilterSessionManager {
  static final SiteFilterSessionManager _singleton =
      SiteFilterSessionManager._internal();

  factory SiteFilterSessionManager() => _singleton;

  SiteFilterSessionManager._internal();

  bool _isFavoriteFilterSelected = false;

  set isFavoriteFilterSelected(bool _isFavoriteFilterSelected) {
    this._isFavoriteFilterSelected = _isFavoriteFilterSelected;
  }

  bool get isFavoriteFilterSelected => _isFavoriteFilterSelected;

  void clear() {
    _isFavoriteFilterSelected = false;
  }
}
