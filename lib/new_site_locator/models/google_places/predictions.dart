// ignore_for_file: must_be_immutable

import 'package:driven_site_locator/new_site_locator/models/google_places/structured_formatting.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'predictions.g.dart';

@HiveType(typeId: SLInternalText.predictionsTypeId)
class Predictions extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String? description;

  @HiveField(1)
  final String? placeId;

  @HiveField(2)
  final String? reference;

  @HiveField(3)
  final StructuredFormatting? structuredFormatting;

  @HiveField(4)
  DateTime? modifiedOn;

  Predictions({
    this.description,
    this.placeId,
    this.reference,
    this.structuredFormatting,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }

  @override
  List<Object?> get props => [placeId];
}
