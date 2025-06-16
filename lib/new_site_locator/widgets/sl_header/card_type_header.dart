part of sl_widget_module;

class CardTypeHeader extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final SelectYourCardController selectYourCardController = Get.find();

  CardTypeHeader({required this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Obx(
        () => Text(
          selectYourCardController.headerValue,
          style: f16SemiBoldBlack,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
