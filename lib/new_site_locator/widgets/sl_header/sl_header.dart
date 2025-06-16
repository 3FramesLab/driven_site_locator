part of sl_widget_module;

class SLHeader extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Future<void> Function()? fleetChangeCallback;
  final bool showAddCard;

  const SLHeader({
    required this.padding,
    required this.fleetChangeCallback,
    this.showAddCard = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_isGuest) {
      return RepresentativePricing(
        padding: padding,
        showAddCard: showAddCard,
      );
    } else if (_isCardholder) {
      return CardHolderHeader(padding: padding);
    } else {
      return FleetHeader(
        padding: padding,
        fleetChangeCallback: fleetChangeCallback,
      );
    }
  }

  bool get _isGuest => DcSiteLocatorUtils.isGuest;

  bool get _isCardholder => DcSiteLocatorUtils.isCardholder;
}
