import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:flutter/material.dart';

class FuelTypesPricesSection extends StatelessWidget {
  const FuelTypesPricesSection(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: _getFuelTypePrice(),
    );
  }

  Widget _getFuelTypePrice() {
    return Row(
      mainAxisAlignment: AppUtils.isFuelman || AppUtils.isIFleet
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.start,
      children: <Widget>[
        if (AppUtils.isFuelman || AppUtils.isIFleet) ...[
          fuelTypeWithPrice(
              FuelTypeLabel.regular, selectedSiteLocation.unleadedRegularPrice),
          fuelTypeWithPrice(
              FuelTypeLabel.midgrade, selectedSiteLocation.unleadedPlusPrice),
          fuelTypeWithPrice(
              FuelTypeLabel.premium, selectedSiteLocation.unleadedPremiumPrice),
          fuelTypeWithPrice(
              FuelTypeLabel.diesel, selectedSiteLocation.dieselPrice),
        ],
      ],
    );
  }

  Widget fuelTypeWithPrice(String type, double? price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type),
        Text(_formatFuelPrice(price),
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _formatFuelPrice(double? price) {
    if (price != null && price != 0) {
      return '\$${price.toStringAsFixed(2)}';
    } else {
      return r'$--.--';
    }
  }
}
