class AdobeTagPropertiesModel {
  List<AdobeCustomLinkTags>? adobeCustomLinkTags;

  AdobeTagPropertiesModel({this.adobeCustomLinkTags});

  AdobeTagPropertiesModel.fromJson(Map<String, dynamic> json) {
    if (json['adobeCustomLinkTags'] != null) {
      adobeCustomLinkTags = <AdobeCustomLinkTags>[];
      json['adobeCustomLinkTags'].forEach((v) {
        adobeCustomLinkTags!.add(AdobeCustomLinkTags.fromJson(v));
      });
    }
  }
}

class AdobeCustomLinkTags {
  String? code;
  List<String>? flavor;

  AdobeCustomLinkTags({this.code, this.flavor});

  AdobeCustomLinkTags.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    flavor = json['flavor'].cast<String>();
  }
}
