import 'dart:convert';

import 'package:driven_common/data/data_sources/remote/decodable.dart';

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

class Predictions {
  String? description;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;

  Predictions({
    this.description,
    this.placeId,
    this.reference,
    this.structuredFormatting,
  });

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
  }
}

class StructuredFormatting {
  String? mainText;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];
    secondaryText = json['secondary_text'];
  }

  @override
  String toString() {
    return '${mainText ?? ''}, ${secondaryText ?? ''}';
  }
}
