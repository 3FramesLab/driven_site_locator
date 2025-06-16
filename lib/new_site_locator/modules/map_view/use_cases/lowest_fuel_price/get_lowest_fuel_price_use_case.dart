part of map_view_module;

class GetLowestFuelPriceUseCase extends BaseUseCase<double?, List<Site>> {
  @override
  double? execute(List<Site> param) {
    double? cheapestPrice;

    for (final site in param) {
      if (site.price != null) {
        final price = site.price;
        if (price != null) {
          if (cheapestPrice == null || price < cheapestPrice) {
            cheapestPrice = price;
          }
        }
      }
    }

    return cheapestPrice;
  }
}
