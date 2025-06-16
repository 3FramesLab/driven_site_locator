part of select_your_card_module;

class CardTypeItem extends StatelessWidget {
  final CardTypeModel cardType;
  final selectYourCardController = Get.find<SelectYourCardController>();

  CardTypeItem({
    required this.cardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isSelected =
            selectYourCardController.selectedCardType() == cardType;
        return GestureDetector(
          onTap: () => selectYourCardController.onCardDetailTap(cardType),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xffe8f5e9) : Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isSelected)
                                Icon(Icons.check_circle,
                                    color: isSelected
                                        ? const Color(0xFF2e7d32)
                                        : null),
                              if (isSelected) const SizedBox(width: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                child: Text(
                                  cardType.title,
                                  style: f16SemiBoldBlack.copyWith(
                                      color: isSelected
                                          ? const Color(0xFF2e7d32)
                                          : null),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(cardType.subtitle,
                              style: f14RegularBlack.copyWith(
                                  color: isSelected
                                      ? const Color(0xFF2e7d32)
                                      : null)),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          ...cardType.cards.map(
                            (card) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: const Offset(-2, 3),
                                      ),
                                    ],
                                  ),
                                  child: card.endsWith('.svg')
                                      ? SvgPicture.asset(card, height: 46)
                                      : Image.asset(card, height: 46),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: Colors.grey, thickness: 1, height: 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
