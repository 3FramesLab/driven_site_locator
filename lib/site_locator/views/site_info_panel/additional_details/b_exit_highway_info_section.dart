import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:flutter/material.dart';

class ExitHighwayInfoSection extends StatelessWidget {
  const ExitHighwayInfoSection(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  @override
  Widget build(BuildContext context) {
    return AppUtils.isComdata ? _exitHighwaySection() : _emptySizedBox();
  }

  Widget _exitHighwaySection() {
    if (_canDisplaySection()) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _directionalIcon(),
            _exitSection(),
            _separator(),
            _highwaySection(),
          ],
        ),
      );
    } else {
      return _emptySizedBox();
    }
  }

  Widget _directionalIcon() {
    return Row(
      children: [
        _exitSignImage,
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _exitSection() {
    final siteLocation = selectedSiteLocation;
    String exitContent = '';
    if (_hasExit()) {
      exitContent = '${SiteLocatorConstants.exit} ${siteLocation.exit}';
    }
    if (exitContent.isEmpty) {
      return _emptySizedBox();
    }

    return Text(exitContent);
  }

  Widget _highwaySection() {
    final siteLocation = selectedSiteLocation;
    String highwayContent = '';
    if (_hasHighway()) {
      highwayContent =
          '${SiteLocatorConstants.highway} ${siteLocation.highway}';
    }

    if (highwayContent.isEmpty) {
      return _emptySizedBox();
    }
    return Text(highwayContent);
  }

  Widget _separator() {
    if (_canDisplaySeparator()) {
      return const Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Text(ViewText.dotSeparator),
      );
    }
    return _emptySizedBox();
  }

  Widget get _exitSignImage => const Image(
        image: AssetImage(SiteLocatorAssets.exitSign),
        height: 20,
      );

  bool _hasExit() =>
      AppUtils.replaceNullString(selectedSiteLocation.exit)?.isNotEmpty ??
      false;

  bool _hasHighway() =>
      AppUtils.replaceNullString(selectedSiteLocation.highway)?.isNotEmpty ??
      false;

  Widget _emptySizedBox() => const SizedBox.shrink();

  bool _canDisplaySection() => _hasExit() || _hasHighway();

  bool _canDisplaySeparator() => _hasExit() && _hasHighway();
}
