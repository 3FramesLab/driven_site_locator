part of map_view_module;

class GetSitesWithLowestFuelPriceUseCase
    extends BaseUseCase<List<Site>, GetSitesWithLowestFuelPriceParam> {
  @override
  List<Site> execute(GetSitesWithLowestFuelPriceParam param) {
    final lowestFuelPrice = param.lowestFuelPrice;
    final sites = param.sites;

    return sites.where((site) {
      if (site.price != null) {
        final price = site.price;
        return price != null && price == lowestFuelPrice;
      } else {
        return false;
      }
    }).toList();
  }
}

class GetSitesWithLowestFuelPriceParam {
  final double lowestFuelPrice;
  final List<Site> sites;

  GetSitesWithLowestFuelPriceParam({
    required this.lowestFuelPrice,
    required this.sites,
  });
}
