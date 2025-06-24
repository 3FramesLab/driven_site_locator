part of map_view_module;

class GallonPreferredSite extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();
  final SiteLocation siteLocation;

  GallonPreferredSite({
    required this.siteLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SiteInfoUtils.isGallonUpPreferredLocation(siteLocation)
        ? _content
        : const SizedBox.shrink();
  }

  Widget get _content => GestureDetector(
        onTap: _showGallonPreferredDialog,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _gallonPreferredLocationText,
              _infoIcon,
            ],
          ),
        ),
      );

  Widget get _gallonPreferredLocationText => const Flexible(
        child: Text(
          SLViewText.gallonPreferredLocation,
          style: f14SemiBoldPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget get _infoIcon => const Padding(
        padding: EdgeInsets.only(left: 2),
        child: Icon(
          Icons.info_outline_rounded,
          color: DrivenColors.primary,
          size: 16,
        ),
      );

  void _showGallonPreferredDialog() {
    Get.dialog(const GallonPreferredDialog());
  }
}
