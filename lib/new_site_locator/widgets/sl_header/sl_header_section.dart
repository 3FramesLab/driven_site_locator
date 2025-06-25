part of sl_widget_module;

class SLHeaderSection extends StatelessWidget {
  const SLHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (!DrivenSiteLocator.instance.useDefaultHeader) {
      return DrivenSiteLocator.instance.fuelCardHeader ?? const SizedBox.shrink();
    }
    return SLHeaderTopContent();
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
