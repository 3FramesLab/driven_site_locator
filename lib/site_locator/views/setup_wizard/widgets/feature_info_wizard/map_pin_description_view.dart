import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/map_pin_with_description.dart';
import 'package:flutter/material.dart';

class MapPinDescriptionView extends StatelessWidget {
  const MapPinDescriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: AppUtils.isComdata
                ? const MapPinWithDescription(
                    mapPinImage: SiteLocatorAssets.pinBgNormalFilePathDFC,
                    mapPinDescription: CardholderSetupConstants.regularSites,
                  )
                : const MapPinWithDescription(
                    mapPinImage:
                        SiteLocatorAssets.discountPriceBannerMapPinFilePath,
                    mapPinDescription: SetUpWizardConstants.sitesWithDiscounts,
                  )),
        separator(),
        Expanded(
            child: AppUtils.isComdata
                ? const MapPinWithDescription(
                    mapPinImage: SiteLocatorAssets.pinBgGallonUpFilePathDFC,
                    mapPinDescription: CardholderSetupConstants.gallonUpSites,
                  )
                : const MapPinWithDescription(
                    mapPinImage:
                        SiteLocatorAssets.networkFeePriceBannerMapPinFilePath,
                    mapPinDescription:
                        SetUpWizardConstants.sitesWithOutDiscounts,
                  )),
        separator(),
        const Expanded(
          child: MapPinWithDescription(
            mapPinImage: SiteLocatorAssets.clusterMapPinFilePath,
            mapPinDescription: SetUpWizardConstants.manySitesClustered,
          ),
        ),
      ],
    );
  }

  SizedBox separator() => const SizedBox(width: 6);
}
