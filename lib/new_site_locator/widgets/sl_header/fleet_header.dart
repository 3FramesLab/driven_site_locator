part of sl_widget_module;

class FleetHeader extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Future<void> Function()? fleetChangeCallback;
  final siteLocatorController = Get.find<SiteLocatorController>();

  FleetHeader({
    required this.padding,
    required this.fleetChangeCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: padding,
        child: GestureDetector(
          onTap: onFleetIdDetailsLinkTap,
          child: _getFleetIdDetailsText(),
        ),
      );
    });
  }

  Widget _getFleetIdDetailsText() => Text(
        _fleetIdLabelText,
        style: f16SemiBoldLinkTeal,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
      );

  Future<void> onFleetIdDetailsLinkTap() async {
    if (DrivenSessionManager().userId.isNotEmpty) {
      late AdminDashboardController adminDashboardController;
      if (Get.isRegistered<AdminDashboardController>()) {
        adminDashboardController = Get.find<AdminDashboardController>();
      } else {
        adminDashboardController = Get.put(AdminDashboardController());
      }
      siteLocatorController.firstTimeLoading(true);
      try {
        await adminDashboardController.getCustomerIdList(
          canCallChangeCustomerAPI: false,
        );
      } catch (_) {}
      siteLocatorController.firstTimeLoading(false);
      adminDashboardController.onCustomerIdTap(
        callBack: fleetChangeCallback,
      );
    }
  }

  String get _fleetIdLabelText => DrivenSessionManager()
          .selectedFleetId()
          .isNotEmpty
      ? '${DrivenSessionManager().selectedFleetId()} - ${DrivenSessionManager().selectedFleetName()}'
      : DrivenSessionManager().defaultFleetId.isNotEmpty
          ? '${DrivenSessionManager().defaultFleetId} - ${DrivenSessionManager().defaultFleetName}'
          : SLViewText.addFleetIdOrCardNumber;
}
