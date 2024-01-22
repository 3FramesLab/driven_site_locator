import 'dart:convert';

import 'package:driven_common/data/data_sources/remote/decodable.dart';

class DistanceMatrix implements Decodable<DistanceMatrix> {
  final List<String>? destinations;
  final List<String>? origins;
  final List<Element>? elements;
  final List<DistanceItem>? distanceList;
  final String? status;

  DistanceMatrix({
    this.destinations,
    this.origins,
    this.elements,
    this.distanceList,
    this.status,
  });

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) {
    final String status = json['status'];
    final List<String> destinationsJson = json['destination_addresses'] != null
        ? List<String>.from(json['destination_addresses'])
        : [];
    final List<String> originsJson = json['origin_addresses'] != null
        ? List<String>.from(json['origin_addresses'])
        : [];
    final elementsJson = status == 'OK' &&
            json['rows'] != null &&
            (json['rows'] as List<dynamic>).isNotEmpty
        ? json['rows'][0]['elements']
        : [];

    return DistanceMatrix(
        destinations: destinationsJson,
        origins: originsJson,
        elements: (elementsJson as List<dynamic>)
            .map((dynamic i) => Element.fromJson(i as Map<String, dynamic>))
            .toList(),
        distanceList: elementsJson
            .map(
                (dynamic i) => DistanceItem.fromJson(i as Map<String, dynamic>))
            .toList(),
        status: status);
  }

  @override
  DistanceMatrix decode(dynamic jsonMap) => DistanceMatrix.fromJson(
        jsonMap is String ? json.decode(jsonMap) : jsonMap,
      );
}

class DistanceItem {
  final String? status;
  final double? miles;

  DistanceItem({this.status, this.miles});

  factory DistanceItem.fromJson(Map<String, dynamic> json) {
    final String milesString = Distance.fromJson(json['distance']).text ?? '';
    final double milesValue = _grabAccurateMiles(milesString);
    return DistanceItem(
      status: json['status'],
      miles: milesValue,
    );
  }

  static double _grabAccurateMiles(String milesString) {
    return milesString.isNotEmpty
        ? double.tryParse(milesString
                .replaceAll(',', '')
                .substring(0, milesString.length - 3)) ??
            0
        : 0;
  }
}

class Element {
  final Distance? distance;
  final DriveDuration? duration;
  final String? status;

  Element({this.distance, this.duration, this.status});

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
        distance: Distance.fromJson(json['distance']),
        duration: DriveDuration.fromJson(json['duration']),
        status: json['status']);
  }
}

class Distance {
  final String? text;
  final int? value;

  Distance({this.text, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(text: json['text'], value: json['value']);
  }
}

class DriveDuration {
  final String? text;
  final int? value;

  DriveDuration({this.text, this.value});

  factory DriveDuration.fromJson(Map<String, dynamic> json) {
    return DriveDuration(text: json['text'], value: json['value']);
  }
}
