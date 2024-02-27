import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_row.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebLocationPreferencesCard extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  WebLocationPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebMenuRow(
      title: _title,
      imageIcon: _icon,
      onRowTap: () {},
    );
  }

  String get _title => SiteLocatorConstants.locationPreferences;

  AssetImage get _icon => const AssetImage(SiteLocatorAssets.mapPin);
}
