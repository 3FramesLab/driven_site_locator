import 'dart:convert';

import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/new_site_locator/models/google_places/predictions.dart';

class GooglePlacesModel implements Decodable<GooglePlacesModel> {
  List<Predictions>? predictions;
  String? status;

  GooglePlacesModel({this.predictions, this.status});

  GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions?.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  @override
  GooglePlacesModel decode(dynamic jsonData) => GooglePlacesModel.fromJson(
        jsonData is String ? json.decode(jsonData) : jsonData,
      );
}
