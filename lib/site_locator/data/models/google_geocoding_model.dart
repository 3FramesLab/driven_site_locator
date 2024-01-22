import 'dart:convert';

import 'package:driven_common/data/data_sources/remote/decodable.dart';

class GoogleGeoCodingModel extends Decodable<GoogleGeoCodingModel> {
  List<Results>? results;
  String? status;

  GoogleGeoCodingModel({this.results, this.status});

  GoogleGeoCodingModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  @override
  GoogleGeoCodingModel decode(dynamic data) => GoogleGeoCodingModel.fromJson(
        data is String ? json.decode(data) : data,
      );
}

class Results {
  Geometry? geometry;
  String? placeId;

  Results({
    this.geometry,
    this.placeId,
  });

  Results.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    placeId = json['place_id'];
  }
}

class Geometry {
  Location? location;
  String? locationType;

  Geometry({
    this.location,
    this.locationType,
  });

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationType = json['location_type'];
  }
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}
