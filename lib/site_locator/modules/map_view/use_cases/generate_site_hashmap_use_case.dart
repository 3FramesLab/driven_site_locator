part of map_view_module;

class GenerateSiteHashmapUseCase
    extends BaseUseCase<void, GenerateSiteHashmapParams> {
  @override
  void execute(GenerateSiteHashmapParams param) {
    param.siteHashmap.clear();
    for (final site in param.sites) {
      try {
        param.siteHashmap[site.location] = site;
      } catch (_) {}
    }
  }
}

class GenerateSiteHashmapParams {
  final Map<LatLng, Site> siteHashmap;
  final List<Site> sites;

  GenerateSiteHashmapParams({
    required this.siteHashmap,
    required this.sites,
  });
}
