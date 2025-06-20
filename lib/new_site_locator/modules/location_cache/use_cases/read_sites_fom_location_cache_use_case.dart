part of location_cache_module;

class ReadSitesFromLocationCacheUseCase extends BaseFutureUseCase<
    List<SiteLocation>?, ReadSitesFromLocationCacheParams> {
  @override
  Future<List<SiteLocation>?>? execute(
      ReadSitesFromLocationCacheParams param) async {
    final List<SiteLocation> sites = [];
    final file = param.locationCacheFile;
    final jsonString = await file.readAsString();

    final jsonMap = json.decode(jsonString);
    for (final item in jsonMap) {
      sites.add(SiteLocation.fromJson(item));
    }
    return sites;
  }
}

class ReadSitesFromLocationCacheParams {
  final File locationCacheFile;

  const ReadSitesFromLocationCacheParams({
    required this.locationCacheFile,
  });
}
