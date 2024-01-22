import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/z_site_info_section_heading.dart';
import 'package:flutter/material.dart';

class ShippingServicesSection extends StatelessWidget {
  final SiteLocation siteLocation;

  const ShippingServicesSection(this.siteLocation, {super.key});

  @override
  Widget build(BuildContext context) {
    return _showShippingServices
        ? _shippingServiceContent
        : const SizedBox.shrink();
  }

  Widget get _shippingServiceContent => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shippingServiceHeader,
            _shippingImages,
          ],
        ),
      );

  Widget get _shippingServiceHeader => const SiteInfoSectionHeading(
        SiteLocatorConstants.shippingServices,
        iconData: Icons.local_shipping_outlined,
      );

  Widget get _shippingImages => Padding(
        padding: EdgeInsets.symmetric(horizontal: _showFedex ? 12 : 6),
        child: Row(
          children: [
            _fedexImage,
            _upsImage,
          ],
        ),
      );

  Widget get _fedexImage => _showFedex
      ? Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Image.asset(
            SiteLocatorAssets.icFedex,
          ),
        )
      : const SizedBox.shrink();

  Widget get _upsImage => _showUps
      ? Padding(
          padding: EdgeInsets.only(top: _showFedex ? 0 : 10),
          child: Image.asset(
            SiteLocatorAssets.icUps,
          ),
        )
      : const SizedBox.shrink();

  bool get _showFedex => siteLocation.services?.fedex == Status.Y;
  bool get _showUps => siteLocation.services?.ups == Status.Y;
  bool get _showShippingServices => _showFedex || _showUps;
}
