part of discount_module;

class ExtendedNetworkFeesPage extends StatelessWidget {
  const ExtendedNetworkFeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiscountPageTemplate(mainView: innerView());
  }

  Widget innerView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _networkTitleText(),
          const SizedBox(height: 16),
          _networkText(),
          const SizedBox(height: 16),
          _networkSubText(),
        ],
      );

  Widget _networkTitleText() {
    return const Text(
      SiteLocatorConstants.extendedNetworkFees,
      style: f28ExtraboldBlackDark,
    );
  }

  Widget _networkText() {
    return const Text(
      SiteLocatorConstants.extendedNetworkText,
      style: f16RegularBlack,
    );
  }

  Widget _networkSubText() {
    return const Text(
      SiteLocatorConstants.extendedSubText,
      style: f16SemiboldBlack,
    );
  }
}
