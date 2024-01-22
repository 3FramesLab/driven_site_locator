import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/widgets/site_info_detail.dart';
import 'package:get/get.dart';

class SiteInfoAddFav extends StatelessWidget {
  SiteInfoAddFav(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  final SiteLocatorController siteLocatorController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Semantics(
        container: true,
        label: SemanticStrings.siteInfoFavorite,
        child: SiteInfoDetail(
          iconData: _getIcon(),
          description: _getDescription(),
          iconColor: _getIconColor(),
          onDescriptionTap: manageFavorites,
          descriptionTextStyle: _descriptionTextStyle(),
        ),
      );
    });
  }

  IconData _getIcon() => siteLocatorController
          .isFavoriteSiteLocation(selectedSiteLocation.siteIdentifier)
      ? Icons.favorite
      : Icons.favorite_border_outlined;

  String _getDescription() => siteLocatorController
          .isFavoriteSiteLocation(selectedSiteLocation.siteIdentifier)
      ? SiteLocatorConstants.removeFromFavorites
      : SiteLocatorConstants.addToFavorites;

  Color _getIconColor() => siteLocatorController
          .isFavoriteSiteLocation(selectedSiteLocation.siteIdentifier)
      ? DrivenColors.brandPurple
      : DrivenColors.textColor;

  TextStyle _descriptionTextStyle() => const DrivenTextStyle(
        16,
        semiBold,
        blackDark,
        decoration: TextDecoration.underline,
      );

  Future<void> manageFavorites() async => siteLocatorController
      .manageFavorite(selectedSiteLocation.siteIdentifier.toString());
}
