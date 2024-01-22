part of discount_module;

class DiscountPageTemplate extends StatelessWidget {
  final DiscountController discountController = Get.find();
  final Widget? mainView;
  DiscountPageTemplate({super.key, this.mainView});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SiteLocatorScaffold(
        backgroundColor: SiteLocatorColors.whiteWithOpacity75,
        body: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Container(
            height: Get.height,
            decoration: _containerDecoration,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _closeIcon(),
                    const SizedBox(height: 5),
                    mainView ?? const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align _closeIcon() => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 2, 20),
          child: GestureDetector(
            onTap: _onCloseIconTap,
            child: const Icon(
              Icons.close,
              size: Discounts.closeIconSize,
            ),
          ),
        ),
      );

  void _onCloseIconTap() => Get.back();

  BoxDecoration get _containerDecoration => const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      );
}
