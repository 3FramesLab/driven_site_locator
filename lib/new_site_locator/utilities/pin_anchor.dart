part of site_locator_module;

class PinAnchor {
  static Offset defaultPoint = const Offset(0.5, 1);
  // static Offset pointWithPrice = const Offset(0.8, 1);
  static Offset pointWithPrice = const Offset(0.5, 1); //const Offset(0.8, 1);

  static Offset point({double? price}) {
    Offset anchorOffset = defaultPoint;
    if (price != null && price > 0) {
      anchorOffset = pointWithPrice;
    }
    return anchorOffset;
  }

  static double priceToDouble({String? price}) => double.parse(price ?? '0');
}
