part of discount_module;

class DiscountSaverDetailsContainer extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final DiscountController discountController = Get.find();
  DiscountSaverDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _deepSaverContainer(),
          _divider(),
          _simpleSaverContainer(),
          _divider(),
          _fuelmanDieselContainer(),
          _divider(),
          _fuelmanMixedContainer(),
        ],
      );
    });
  }

  Widget _divider() => const SizedBox(height: SiteLocatorDimensions.dp32);

  Widget _deepSaverContainer() => deepSaverDetailsView();

  Widget deepSaverDetailsView() =>
      discountController.isShowDeepSaverNotAvailableDetails
          ? noDeepSaverDiscountAvailableView()
          : DiscountSaverDetailView(
              discountType: Discounts.deepSaverFleetCard.toUpperCase(),
              dieselValue: Discounts.deepSaverDieselRebate,
              unleadedValue: Discounts.deepSaverUnleadedRebate,
            );

  Widget noDeepSaverDiscountAvailableView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Discounts.deepSaverFleetCard.toUpperCase(),
            style: f16BoldBlackDark,
          ),
          const SizedBox(height: 12),
          const Text(
            Discounts.deepSaverDiscountNotAvailableTextInTwoLines,
            style: f16SemiboldBlack,
            textAlign: TextAlign.left,
          ),
        ],
      );

  Widget _simpleSaverContainer() => DiscountSaverDetailView(
        discountType: Discounts.simpleSaverFleetCard.toUpperCase(),
        dieselValue: discountController.simpleSaverDiscountValue,
        unleadedValue: discountController.simpleSaverDiscountValue,
      );

  Widget _fuelmanDieselContainer() => DiscountSaverDetailView(
        discountType: Discounts.fuelmanDieselFleetCard.toUpperCase(),
        dieselValue: Discounts.fulemanDieselFleetCardDieselRebate,
        unleadedValue: '',
      );

  Widget _fuelmanMixedContainer() => DiscountSaverDetailView(
        discountType: Discounts.fuelmanMixedFleetCard.toUpperCase(),
        dieselValue: Discounts.fulemanMixedFleetCardDieselUnLeadedRebate,
        unleadedValue: Discounts.fulemanMixedFleetCardDieselUnLeadedRebate,
      );
}
