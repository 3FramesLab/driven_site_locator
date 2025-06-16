part of site_ratings_module;

class GetPlaceIdForSiteUseCase
    extends BaseFutureUseCase<String?, GetPlaceIdForSiteParam> {
  final HiveInterface hive;

  const GetPlaceIdForSiteUseCase({required this.hive});

  @override
  Future<String?> execute(GetPlaceIdForSiteParam param) async {
    try {
      final box = await hive.openBox<SitePlaceId>(
        DrivenConstants.sitePlaceIdBox,
      );

      if (box.containsKey(param.masterIdentifier)) {
        final sitePlaceId = box.get(param.masterIdentifier);
        return sitePlaceId?.placeId;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

class GetPlaceIdForSiteParam {
  final String masterIdentifier;

  GetPlaceIdForSiteParam({required this.masterIdentifier});
}
