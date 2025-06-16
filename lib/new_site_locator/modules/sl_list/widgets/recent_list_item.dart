part of sl_list_module;

class RecentListItem extends StatelessWidget {
  final siteLocatorController = Get.find<SiteLocatorController>();
  final SiteLocation siteLocation;
  final int index;

  RecentListItem({
    required this.siteLocation,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => siteDetailPopup(siteLocation),
      child: Container(
        color: SiteInfoUtils.getCardBgColor(index),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrivenText(
              text: SiteInfoUtils.getLocationName(siteLocation),
              style: f16SemiboldPrimary.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            _drivingMiles(),
          ],
        ),
      ),
    );
  }

  Widget _drivingMiles() {
    return Obx(() {
      final milesData = siteLocatorController.displayMiles(siteLocation);

      String milesApart = '';

      if (siteLocatorController.isLocationEnabled) {
        milesApart = SiteInfoUtils.formatMiles(milesData, defaultValue: '');
      }

      return RichText(
        text: TextSpan(children: [
          if (milesApart.trim().isNotEmpty)
            TextSpan(
              text: '$milesApart   ',
              style: f16SemiBoldBlack,
            ),
          TextSpan(
            text: SiteInfoUtils.getFullAddress(siteLocation),
            style: f16RegularGrey,
          ),
        ]),
      );
    });
  }
}
