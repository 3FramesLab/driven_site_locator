import 'package:driven_common/driven_common_resources_module.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UseCurrentLocationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrivenDialog(
      height: 100,
      width: 350,
      text: _message(),
      primaryButton: _primaryButton(context),
      isDynamicAlert: true,
      secondaryRightButtonOnPressed: _onCancelButtonTap,
      secondaryBody: Text(SiteLocatorConstants.continueWithoutUsingMyLocation),
    );
  }

  void _onCancelButtonTap() {
    Get.back();
  }

  List<TextSpan> _message() => [
        const TextSpan(
          text: SiteLocatorConstants.useMyLocation,
        )
      ];

  Widget _primaryButton(BuildContext context) => PrimaryButton(
        onPressed: Get.back,
        text: SiteLocatorConstants.useMyLocationButton,
      );
}
