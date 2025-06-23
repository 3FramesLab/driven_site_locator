// ignore: one_member_abstracts
abstract class AccessTokenRepository {
  Future<dynamic> getIFrameAccessToken({Map<String, dynamic> jsonData});
  Future<dynamic> getJWTAccessToken({Map<String, dynamic> jsonData});
}
