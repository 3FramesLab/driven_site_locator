import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class EnableLocationServiceDialogMobile extends StatelessWidget {
  EnableLocationServiceDialogMobile();
  final SiteLocatorController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: DrivenDialog(
        height: getDialogHeight(),
        width: 390,
        text: _message(),
        primaryButton: _primaryButton(context),
        isAlignedLeft: true,
        hasSmallContentHeight: true,
        crossAxisAlignment: getDialogCrossAxisAlignment(),
      ),
    );
  }

  void _onOkButtonTap() => Get.back();

  List<TextSpan> _message() => controller.getEnableLocationContent();

  Widget _primaryButton(BuildContext context) => PrimaryButton(
        onPressed: _onOkButtonTap,
        text: ViewText.ok,
      );

  double getDialogHeight() => GetPlatform.isAndroid ? 50 : 300;

  CrossAxisAlignment getDialogCrossAxisAlignment() => CrossAxisAlignment.center;
  // isOtherBrowser() ? CrossAxisAlignment.center : CrossAxisAlignment.start;

// Return false if browser is other than chrome or safari

  bool isOtherBrowser() =>
      !(controller.browserName() == SiteLocatorConstants.chromeBrowser ||
          controller.browserName() == SiteLocatorConstants.safariBrowser);
}
