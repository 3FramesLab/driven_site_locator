part of sl_widget_module;

class AddCard extends StatelessWidget {
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

  const AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _addCard;
  }

  Widget get _addCard => _entitlementRepository.isGuestAddCardEnabled
      ? ClickableText(
          title: 'Add card',
          onTap: DrivenSiteLocator.instance.onAddCardTap,
        )
      : const SizedBox.shrink();
}
