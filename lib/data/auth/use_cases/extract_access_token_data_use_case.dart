import 'dart:convert';

import 'package:driven_site_locator/data/use_cases/base_usecase.dart';

class ExtractAccessTokenDataUseCase
    extends BaseUseCase<Map<String, dynamic>, AccessTokenData> {
  @override
  Map<String, dynamic> execute(AccessTokenData param) {
    return parseJwt(param.accessToken);
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}

class AccessTokenData {
  String accessToken;

  AccessTokenData(this.accessToken);
}
