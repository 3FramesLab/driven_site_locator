class SLSessionManager {
  static final SLSessionManager _singleton = SLSessionManager._internal();

  factory SLSessionManager() => _singleton;

  SLSessionManager._internal();
}
