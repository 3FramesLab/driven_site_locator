part of discount_module;

class DiscountAmountPage extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final DiscountController discountController = Get.find();
  DiscountAmountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiscountPageTemplate(mainView: mainView());
  }

  Widget mainView() => Padding(
        padding: const EdgeInsets.only(
          left: SiteLocatorDimensions.dp22,
          right: SiteLocatorDimensions.dp20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _viewDiscountAmountTitle(),
            const SizedBox(height: SiteLocatorDimensions.dp32),
            DiscountSaverDetailsContainer(),
            const SizedBox(height: SiteLocatorDimensions.dp32),
            _divider(),
            const SizedBox(height: SiteLocatorDimensions.dp24),
            _consultYourProgramManager(),
          ],
        ),
      );

  Widget _divider() => Container(
        height: SiteLocatorDimensions.dpPoint25,
        color: DrivenColors.grey,
      );

  Text _viewDiscountAmountTitle() => const Text(
        Discounts.viewDiscountAmount,
        style: f28ExtraboldBlackDark,
      );

  Text _consultYourProgramManager() => const Text(
        Discounts.consultYourProgramManagerMessage,
        style: f14RegularGrey,
      );
}
