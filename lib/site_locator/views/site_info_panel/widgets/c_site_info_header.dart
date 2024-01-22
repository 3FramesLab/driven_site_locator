import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';

class SiteInfoHeader extends StatelessWidget {
  const SiteInfoHeader(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            headerWidget(),
            fuelTitleWidget(),
          ],
        ),
        locationNameWidget()
      ],
    );
  }

  Widget headerWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _logoTitleWidget(),
      ],
    );
  }

  Widget _logoTitleWidget() {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _brandLogo(),
          const HorizontalSpacer(size: 4),
          fuelBrandNameWidget(),
          const HorizontalSpacer(size: 4),
          if (AppUtils.isFuelman || AppUtils.isIFleet) fuelPriceWidget(),
        ],
      ),
    );
  }

  Semantics _brandLogo() {
    return Semantics(
      container: true,
      label: SemanticStrings.siteInfoBrandLogo,
      child: SiteInfoUtils.getDisplayBrandLogo(selectedSiteLocation),
    );
  }

  Widget fuelPriceWidget() {
    return Semantics(
      container: true,
      label: SemanticStrings.siteInfoFuelPrice,
      child: Text(
        SiteInfoUtils.getFuelPrice(selectedSiteLocation),
        style: f28ExtraboldBlackDark,
      ),
    );
  }

  Widget fuelBrandNameWidget() {
    return Expanded(
      child: Semantics(
        container: true,
        label: SemanticStrings.siteInfoFuelBrandName,
        child: Text(
          SiteInfoUtils.displayFuelBrandName(selectedSiteLocation),
          style: canDisplayLocationName()
              ? f28ExtraboldBlackDark
              : f16SemiboldBlack,
          overflow: TextOverflow.ellipsis,
          maxLines: canDisplayLocationName() ? 1 : 2,
        ),
      ),
    );
  }

  Widget fuelTitleWidget() {
    return Positioned(
      top: 0,
      right: 4,
      child: Semantics(
        container: true,
        label: SemanticStrings.siteInfoFuelTitle,
        child: Text(
          SiteInfoUtils.getFuelTitle(selectedSiteLocation),
          style: const TextStyle(
            fontFamily: DrivenFonts.avertaFontFamily,
            fontWeight: bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  bool canDisplayLocationName() =>
      selectedSiteLocation.fuelBrand != null &&
      SiteInfoUtils.isFuelBrandNameAvailable(selectedSiteLocation);

  Widget locationNameWidget() {
    if (canDisplayLocationName()) {
      return Semantics(
        container: true,
        label: SemanticStrings.siteInfoLocationName,
        child: Text(
          SiteInfoUtils.getLocationName(selectedSiteLocation),
          style: f16SemiboldBlack,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
