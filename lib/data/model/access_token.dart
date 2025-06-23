import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';

class AccessToken implements Decodable<AccessToken> {
  AccessToken({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
  });

  String? tokenType;
  int? expiresIn;
  String? accessToken;

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        accessToken: json['access_token'],
      );
  @override
  AccessToken decode(dynamic json) => AccessToken.fromJson(json);
}
