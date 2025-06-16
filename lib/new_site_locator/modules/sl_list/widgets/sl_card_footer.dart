part of sl_list_module;

class SLCardDetailsFooter extends StatelessWidget {
  final SiteLocation siteLocation;

  const SLCardDetailsFooter({
    required this.siteLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SiteInfoPopupBottomContent(siteLocation),
          const SizedBox(height: 8),
          SiteInfoActionButtons(siteLocation),
        ],
      ),
    );
  }
}
