import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/b_exit_highway_info_section.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/b_fuel_types_prices_section.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/c_amenities_features_section.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/e_fuel_price_disclaimer_info.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/f_shipping_services_section.dart';
import 'package:flutter/material.dart';

class AdditionalDetailsContainer extends StatelessWidget {
  const AdditionalDetailsContainer(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FuelPriceDisclaimerInfo(selectedSiteLocation),
        _fuelTypesPricesVariantSection,
        _exitHighwayInfoSection,
        AmenitiesFeaturesSection(selectedSiteLocation),
        _shippingServicesSection,
      ],
    );
  }

  Widget get _shippingServicesSection => AppUtils.isComdata
      ? ShippingServicesSection(selectedSiteLocation)
      : const SizedBox.shrink();

  Widget get _exitHighwayInfoSection => AppUtils.isComdata
      ? ExitHighwayInfoSection(selectedSiteLocation)
      : const SizedBox.shrink();

  Widget get _fuelTypesPricesVariantSection => AppUtils.isComdata
      ? const SizedBox.shrink()
      : FuelTypesPricesSection(selectedSiteLocation);
}
