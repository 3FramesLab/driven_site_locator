part of sl_widget_module;

class SLHeaderSection extends StatelessWidget {
  const SLHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (!DrivenSiteLocator.instance.useDefaultHeader) {
      return getHeaderWidget();
    }
    return SLHeaderTopContent();
  }

  Widget getHeaderWidget() {
    if (DrivenSiteLocator.instance.isUserAuthenticated) {
      return DrivenSiteLocator.instance.walletHeader ?? const SizedBox.shrink();
    }
    return DrivenSiteLocator.instance.fuelCardHeader ?? const SizedBox.shrink();
  }

  /// archive
  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       UnAuthSLHeaderTopContent(),
  //       AuthSLTypeChoices(),
  //       SlMapLoader(),
  //     ],
  //   );
  // }
}
