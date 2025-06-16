part of site_ratings_module;

class SaveSitePlaceIdUseCase
    extends BaseFutureUseCase<bool, SaveSitePlaceIdParam> {
  final HiveInterface hive;

  const SaveSitePlaceIdUseCase({required this.hive});

  @override
  Future<bool>? execute(SaveSitePlaceIdParam param) async {
    try {
      final box = await hive.openBox<SitePlaceId>(
        DrivenConstants.sitePlaceIdBox,
      );

      final sitePlaceId = SitePlaceId(
        masterIdentifier: param.masterIdentifier,
        placeId: param.placeId,
      );

      await box.put(sitePlaceId.masterIdentifier, sitePlaceId);
      return true;
    } catch (_) {
      return false;
    }
  }
}

class SaveSitePlaceIdParam {
  final String masterIdentifier;
  final String placeId;

  SaveSitePlaceIdParam({
    required this.masterIdentifier,
    required this.placeId,
  });
}
