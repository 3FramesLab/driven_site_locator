import 'dart:convert';

import 'package:driven_common/data/data_sources/remote/decodable.dart';

class BrandLogoUrls extends Decodable<List<dynamic>> {
  final List<dynamic>? list;

  BrandLogoUrls({
    this.list,
  });

  factory BrandLogoUrls.fromJson(dynamic dataMapList) {
    return BrandLogoUrls(list: dataMapList is List ? dataMapList : []);
  }

  @override
  List<BrandLogoUrls> decode(dynamic data) {
    final List<BrandLogoUrls> logoList = [];
    logoList.add(BrandLogoUrls.fromJson(
      data is String ? json.decode(data) : data,
    ));
    return logoList;
  }
}
