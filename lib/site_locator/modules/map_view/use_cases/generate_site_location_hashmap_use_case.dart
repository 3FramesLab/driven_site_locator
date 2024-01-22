part of map_view_module;

class GenerateSiteLocationHashmapUseCase
    extends BaseUseCase<void, GenerateSiteLocationHashmapParams> {
  @override
  void execute(GenerateSiteLocationHashmapParams param) {
    param.siteLocationHashmap.clear();
    for (final siteLocation in param.siteLocations) {
      try {
        if (siteLocation.masterIdentifier != null) {
          param.siteLocationHashmap[siteLocation.masterIdentifier!] =
              siteLocation;
        }
      } catch (_) {}
    }
  }
}

class GenerateSiteLocationHashmapParams {
  final Map<String, SiteLocation> siteLocationHashmap;
  final List<SiteLocation> siteLocations;

  GenerateSiteLocationHashmapParams({
    required this.siteLocationHashmap,
    required this.siteLocations,
  });
}
