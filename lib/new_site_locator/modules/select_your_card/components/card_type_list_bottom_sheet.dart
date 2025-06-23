part of select_your_card_module;

class CardTypeListBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.7,
      decoration: boxDecor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: headingTexts(),
            ),
          ),
          SizedBox(
            height: Get.height * .55,
            child: CardTypeList(),
          ),
        ],
      ),
    );
  }

  List<Widget> headingTexts() {
    return [
      const VerticalSpacer(size: 14),
      const Text(SLViewText.filterBy, style: f14RegularGrey),
      const VerticalSpacer(size: 10),
      const Text(SLViewText.cardType, style: f24SemiBoldBlack),
      const VerticalSpacer(size: 4),
    ];
  }

  BoxDecoration get boxDecor => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        color: Colors.white,
      );
}
