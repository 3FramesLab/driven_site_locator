part of map_view_module;

class DiscountedPrice extends StatelessWidget {
  final double? discountPrice;
  final double? retailPrice;
  final String fuelType;

  const DiscountedPrice({
    required this.fuelType,
    required this.discountPrice,
    required this.retailPrice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _isDiscountAvailable || _isRetailAvailable
        ? getPriceRow()
        : const SizedBox.shrink();
  }

  Widget getPriceWithRetail() {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _fuelType(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '\$${retailPrice!.toStringAsFixed(2)}',
            style: f20ExtraboldPrimary,
            textAlign: TextAlign.left,
            textScaler: _textScaler,
          ),
        ),
      ],
    );
  }

  Widget _fuelType() {
    return Text(
      fuelType,
      style: f16ExtraBoldBlack,
      overflow: TextOverflow.ellipsis,
      textScaler: _textScaler,
    );
  }

  Widget _boldPrice() {
    if (_isDiscountAvailable) {
      return Text(
        '\$${discountPrice!.toStringAsFixed(2)}',
        style: f20ExtraboldPrimary,
        textAlign: TextAlign.left,
        textScaler: _textScaler,
      );
    } else if (_isRetailAvailable) {
      return Text(
        '\$${retailPrice!.toStringAsFixed(2)}',
        style: f20ExtraboldPrimary,
        textAlign: TextAlign.left,
        textScaler: _textScaler,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _strikePrice() {
    if (_isBothPriceAvailable) {
      return Text(
        '\$${retailPrice!.toStringAsFixed(2)}',
        style: f16SemiBoldGrey.copyWith(
          decoration: TextDecoration.lineThrough,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: TextAlign.left,
        textScaler: _textScaler,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // Widget _verticalDivider() {
  //   return _isBothPriceAvailable
  //       ? Container(
  //           width: 1,
  //           height: double.infinity,
  //           color: DrivenColors.grey,
  //           margin: const EdgeInsets.symmetric(vertical: 2),
  //         )
  //       : const SizedBox.shrink();
  // }

  Widget _savingText() {
    if (_isBothPriceAvailable) {
      final displayText = DcSiteLocatorUtils.getGallonSavingText(
        retailPrice: retailPrice!,
        discountPrice: discountPrice!,
      );

      if (displayText.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: DrivenColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            displayText,
            style: f12SemiboldWhite,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textScaler: _textScaler,
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget getPriceRow() {
    return IntrinsicHeight(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: _fuelType(),
          ),
          Expanded(
            flex: 3,
            child: _boldPrice(),
          ),
          Expanded(
            flex: 2,
            child: _strikePrice(),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 5,
            child: _savingText(),
          ),
        ],
      ),
    );
  }

  bool get _isRetailAvailable => retailPrice != null && retailPrice! > 0;

  bool get _isDiscountAvailable =>
      (discountPrice != null && discountPrice! > 0) &&
      discountPrice != retailPrice;

  bool get _isBothPriceAvailable => _isRetailAvailable && _isDiscountAvailable;

  TextScaler get _textScaler => const TextScaler.linear(1);
}
