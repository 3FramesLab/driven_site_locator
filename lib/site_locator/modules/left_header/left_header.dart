import 'package:driven_site_locator/site_locator/modules/left_header/filter_button/filters_button.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/route_planner_button/route_planner_button.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/widgets/menu_and_searchbar.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/widgets/top_menu_logo_header.dart';
import 'package:flutter/material.dart';

class LeftHeader extends StatelessWidget {
  final double padding;
  const LeftHeader({Key? key, this.padding = 20}) : super(key: key);

  const LeftHeader.nopadding({
    Key? key,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          // if (CustomUI.hasToShowTopMenuAndLogo(context))
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20),
          //     child: SiteLocationsSearchBar(),
          //   ),
          // if (!CustomUI.hasToShowTopMenuAndLogo(context)) MenuAndSearchbar(),
          MenuAndSearchbar(),
           Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(child: FiltersButton()),
                SizedBox(width: 24),
                Expanded(child: RoutePlannerButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
