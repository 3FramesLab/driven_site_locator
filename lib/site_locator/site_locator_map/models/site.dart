import 'package:google_maps_flutter/google_maps_flutter.dart';

class Site {
  final String id;
  final String shopName;
  final double latitude;
  final double longitude;
  final String? price;
  final bool hasDiscount;
  final bool hasGallonUp;
  final String? brandLogoIdentifier;

  Site({
    required this.id,
    required this.shopName,
    required this.latitude,
    required this.longitude,
    this.price,
    this.hasDiscount = false,
    this.hasGallonUp = false,
    this.brandLogoIdentifier,
  });

  LatLng get location => LatLng(latitude, longitude);
}
