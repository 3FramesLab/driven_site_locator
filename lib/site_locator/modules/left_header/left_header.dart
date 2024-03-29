import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/filter_button/filters_button.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/route_planner_button/route_planner_button.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/widgets/top_menu_logo_header.dart';
import 'package:driven_site_locator/site_locator/modules/search_locations/search_location_module.dart';
import 'package:flutter/material.dart';

class LeftHeader extends StatelessWidget {
  final double padding;

  const LeftHeader({Key? key, this.padding = SiteLocatorDimensions.dp16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.8),
            width: 1.25,
          ),
        ),
      ),
      child: Column(
        children: [
          TopMenuLogoHeader(),
          const SearchPlaceTextField(),
          const SizedBox(height: SiteLocatorDimensions.dp24),
          if (_entitlementRepository.isEnhancedFilterEnabled) ...[
            FiltersButton()
          ] else ...[
            const RoutePlannerButton(),
          ],
        ],
      ),
    );
  }
}
