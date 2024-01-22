import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_filters_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/d_services_common_section.dart';

class AmenitiesFeaturesSection extends StatelessWidget {
  const AmenitiesFeaturesSection(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  @override
  Widget build(BuildContext context) {
    final amenitiesList = getAmenities();
    final featuresList = getFeatures();
    return amenitiesList.isEmpty && featuresList.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1, color: DrivenColors.dividerColor),
              _displayAmenitiesSection(amenitiesList),
              _displayLocationFeaturesSection(featuresList),
            ],
          );
  }

  Widget _displayAmenitiesSection(amenitiesList) {
    return Padding(
      padding: EdgeInsets.only(top: amenitiesList.isNotEmpty ? 10 : 0),
      child: ServicesCommonSection(
          SiteLocatorConstants.amenitiesHeading, amenitiesList),
    );
  }

  Widget _displayLocationFeaturesSection(featuresList) {
    return Padding(
      padding: EdgeInsets.only(top: featuresList.isNotEmpty ? 15 : 0),
      child: ServicesCommonSection(
          SiteLocatorConstants.locationFeaturesHeading, featuresList),
    );
  }

  List<Widget> getAmenities() {
    final List<Widget> amenitiesListWidgets = <Widget>[];
    final siteServices = selectedSiteLocation.services;
    if (siteServices != null) {
      final jsonMap = siteServices.toJson();
      if (jsonMap.keys.isNotEmpty) {
        for (final item in SiteFilters.amenitiesList) {
          if (yOrNToBool(jsonMap[item.key] ?? 'N')) {
            amenitiesListWidgets.add(DrivenBulletText(item.label));
          }
        }
      }
    }
    return amenitiesListWidgets;
  }

  List<Widget> getFeatures() {
    final List<Widget> featuresListWidgets = <Widget>[];
    final siteServices = selectedSiteLocation.services;
    if (siteServices != null) {
      final jsonMap = siteServices.toJson();
      if (jsonMap.keys.isNotEmpty) {
        for (final item in SiteFilters.featuresList) {
          if (yOrNToBool(jsonMap[item.key] ?? 'N')) {
            featuresListWidgets.add(DrivenBulletText(item.label));
          }
        }
      }
    }

    return featuresListWidgets;
  }
}
