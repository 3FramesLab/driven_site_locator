class DieselPricesPack {
  final DieselPriceDisplay whichPrice;
  final String netPrice;
  final String retailPrice;
  final String typeLabel;

  DieselPricesPack({
    required this.whichPrice,
    required this.netPrice,
    required this.retailPrice,
    required this.typeLabel,
  });
}

enum DieselPriceDisplay {
  both,
  netOnly,
  retailOnly,
  nothing,
}

enum FuelPriceAsOfDateBannerViewType {
  infoPanel,
  listCard,
}

class FuelPriceAsOfDisplayEntity {
  final bool canShow;
  final String displayDate;

  FuelPriceAsOfDisplayEntity({
    required this.canShow,
    required this.displayDate,
  });
}
