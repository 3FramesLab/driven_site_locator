import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class SiteLocatorScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Color? backgroundColor;

  SiteLocatorScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.backgroundColor,
  }) : super(key: key);

  final SiteLocatorController _siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return BaseDrivenScaffold(
      backgroundColor: backgroundColor,
      goesInactive: _isLoggedIn,
      appBar: appBar,
      body: body,
      isInactivityWrapperActivated:
          DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
      onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
    );
  }

  bool get _isLoggedIn => _siteLocatorController.isUserAuthenticated;
}
