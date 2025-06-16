import 'package:driven/constants/driven_constants.dart';
import 'package:hive/hive.dart';

part 'site_place_id.g.dart';

@HiveType(typeId: DrivenConstants.sitePlaceIdTypeId)
class SitePlaceId extends HiveObject {
  @HiveField(0)
  final String masterIdentifier;

  @HiveField(1)
  final String placeId;

  SitePlaceId({
    required this.masterIdentifier,
    required this.placeId,
  });
}
