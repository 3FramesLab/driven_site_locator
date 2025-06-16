part of sl_list_module;

class ListItemPrice extends StatelessWidget {
  final double? discountPrice;
  final double? retailPrice;
  final String fuelType;

  const ListItemPrice({
    required this.fuelType,
    required this.discountPrice,
    required this.retailPrice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _isDiscountAvailable || _isRetailAvailable
        ? getPriceColumn()
        : const SizedBox.shrink();
  }

  Widget get _fuelTypeText => Text(
        fuelType,
        style: f14SemiboldGrey,
        textScaler: _textScaler,
      );

  Widget _strikePrice() {
    if (_isBothPriceAvailable) {
      return Text(
        '\$${retailPrice!.toStringAsFixed(2)}',
        style: f14RegularGrey.copyWith(
          decoration: TextDecoration.lineThrough,
        ),
        textScaler: _textScaler,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _spacer() {
    return SizedBox(width: _isBothPriceAvailable ? 3 : 0);
  }

  Widget _boldPrice() {
    if (_isDiscountAvailable) {
      return Text(
        '\$${discountPrice!.toStringAsFixed(2)}',
        style: f20ExtraboldPrimary,
        textScaler: _textScaler,
      );
    } else if (_isRetailAvailable) {
      return Text(
        '\$${retailPrice!.toStringAsFixed(2)}',
        style: f20ExtraboldPrimary,
        textScaler: _textScaler,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getPriceColumn() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _fuelTypeText,
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _strikePrice(),
              _spacer(),
              _boldPrice(),
            ],
          ),
          // const SizedBox(height: 8),
        ],
      ),
    );
  }

  bool get _isRetailAvailable => retailPrice != null && retailPrice! > 0;

  bool get _isDiscountAvailable =>
      discountPrice != null &&
      discountPrice! > 0 &&
      discountPrice != retailPrice;

  bool get _isBothPriceAvailable => _isRetailAvailable && _isDiscountAvailable;

  TextScaler get _textScaler => const TextScaler.linear(1);
}
