part of sl_widget_module;

class AddCard extends StatelessWidget {
  final _entitlementRepository = Get.find<EntitlementRepository>();
  final GuestHomeController controller = Get.find();

  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _addCard;
  }

  Widget get _addCard => _entitlementRepository.isGuestAddCardEnabled
      ? ClickableText(title: 'Add card', onTap: controller.onAddCardTap)
      : const SizedBox.shrink();
}
