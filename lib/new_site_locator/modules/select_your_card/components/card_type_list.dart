part of select_your_card_module;

class CardTypeList extends StatelessWidget {
  final controller = Get.find<SelectYourCardController>();

  CardTypeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: controller.cardTypes().length,
        itemBuilder: (context, index) {
          final cardDetail = controller.cardTypes()[index];
          return CardTypeItem(
            cardType: cardDetail,
          );
        },
      ),
    );
  }
}
