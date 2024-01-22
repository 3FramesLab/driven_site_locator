import 'package:driven_common/data/data_sources/remote/decodable.dart';

class SiteLocatorAccessToken implements Decodable<SiteLocatorAccessToken> {
  SiteLocatorAccessToken({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
  });

  String? tokenType;
  int? expiresIn;
  String? accessToken;

  factory SiteLocatorAccessToken.fromJson(Map<String, dynamic> json) =>
      SiteLocatorAccessToken(
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        accessToken: json['access_token'],
      );
  @override
  SiteLocatorAccessToken decode(dynamic json) =>
      SiteLocatorAccessToken.fromJson(json);
}
