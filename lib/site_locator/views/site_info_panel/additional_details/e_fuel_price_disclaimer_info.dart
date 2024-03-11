import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';

class FuelPriceDisclaimerInfo extends StatelessWidget {
  final SiteLocation siteLocation;

  const FuelPriceDisclaimerInfo(this.siteLocation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _canDisplay()
        ? PaddedRow(
            padding: const EdgeInsets.only(bottom: SiteLocatorDimensions.dp16),
            children: _disclaimerInfoSection(),
          )
        : const SizedBox.shrink();
  }

  bool _canDisplay() {
    bool displayFlag = true;
    if (!SiteLocatorConfig.hasGallonNetwork(siteLocation) &&
        AppUtils.isComdata) {
      displayFlag = false;
    }
    return displayFlag;
  }

  List<Widget> _disclaimerInfoSection() => [
        _infoIcon(),
        _divider(),
        _disclaimerInfoText(),
      ];

  Widget _infoIcon() => Image(
        image: AssetImage(SiteLocatorAssets.fuelPriceDisclaimerInfoIcon),
        height: SiteLocatorDimensions.dp20,
        width: SiteLocatorDimensions.dp20,
      );

  Widget _divider() => Container(
        width: SiteLocatorDimensions.dp1,
        height: SiteLocatorDimensions.dp40,
        color: DrivenColors.grey,
        margin: const EdgeInsets.symmetric(
          horizontal: SiteLocatorDimensions.dp8,
        ),
      );

  Widget _disclaimerInfoText() {
    if (SiteLocatorConfig.hasGallonNetwork(siteLocation) &&
        AppUtils.isComdata) {
      return _gallonUpDisclaimerRichText();
    } else {
      return _fuelPriceText();
    }
  }

  Widget _fuelPriceText() => const Expanded(
        child: Text(
          SiteLocatorConstants.fuelPriceDisclaimer,
          style: f12RegularGrey,
        ),
      );

  Widget _gallonUpDisclaimerRichText() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          style: f12RegularGrey,
          children: <TextSpan>[
            TextSpan(text: SiteLocatorConstants.gallonUpDisclaimer[0]),
            TextSpan(
              text: SiteLocatorConstants.gallonUpDisclaimer[1],
              style: f12SemiboldGrey,
            ),
            TextSpan(text: SiteLocatorConstants.gallonUpDisclaimer[2]),
            TextSpan(text: SiteLocatorConstants.gallonUpDisclaimer[3]),
          ],
        ),
      ),
    );
  }
}
