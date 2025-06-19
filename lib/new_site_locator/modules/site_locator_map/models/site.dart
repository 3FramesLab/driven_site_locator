part of site_locator_map_module;

class Site {
  final String id;
  final String shopName;
  final double latitude;
  final double longitude;
  final double? price;
  final bool hasDiscount;
  final bool hasGallonUp;
  final String? brandLogoIdentifier;
  final bool isServiceStation;

  Site({
    required this.id,
    required this.shopName,
    required this.latitude,
    required this.longitude,
    this.price,
    this.hasDiscount = false,
    this.hasGallonUp = false,
    this.brandLogoIdentifier,
    this.isServiceStation = false,
  });

  LatLng get location => LatLng(latitude, longitude);
}
