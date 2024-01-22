part of discount_module;

class DiscountSaverDetailView extends StatelessWidget {
  final String? discountType;
  final String? dieselValue;
  final String? unleadedValue;
  const DiscountSaverDetailView({
    this.discountType,
    this.dieselValue,
    this.unleadedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _discountTypeTitle(),
        const SizedBox(height: SiteLocatorDimensions.dp8),
        _dieselRebate(),
        const SizedBox(height: SiteLocatorDimensions.dp6),
        _unLeadedRebate(),
      ],
    );
  }

  Text _discountTypeTitle() =>
      Text(discountType ?? '', style: f16ExtraBoldBlackDark);

  Text _dieselRebate() => Text(
        '${Discounts.dieselRebate} - \$$dieselValue/${Discounts.gal}',
        style: f16SemiboldBlackDark,
      );

  Widget _unLeadedRebate() => unleadedValue != null && unleadedValue!.isNotEmpty
      ? Text(
          '${Discounts.unleadedRebate} - \$$unleadedValue/${Discounts.gal}',
          style: f16SemiboldBlackDark,
        )
      : const SizedBox();
}
