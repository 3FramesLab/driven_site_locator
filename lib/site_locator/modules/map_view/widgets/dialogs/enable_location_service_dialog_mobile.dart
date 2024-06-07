import 'package:app_settings/app_settings.dart';
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
      child: GetPlatform.isAndroid
          ? _androidLocationDialog(context)
          : _iosLocationDialog(context),
    );
  }

  DrivenDialog _androidLocationDialog(BuildContext context) => DrivenDialog(
        height: 60,
        width: 390,
        text: _message(),
        primaryButton: _primaryButton(context),
        hasSmallContentHeight: true,
        crossAxisAlignment: getDialogCrossAxisAlignment(),
      );

  DrivenDialog _iosLocationDialog(BuildContext context) => DrivenDialog(
        height: 95,
        width: 390,
        text: _message(),
        primaryButton: _primaryButton(context),
        clickableText: SiteLocatorConstants.cancel,
        onClickableTextPressed: _onOkButtonTap,
        hasSmallContentHeight: true,
        crossAxisAlignment: getDialogCrossAxisAlignment(),
      );

  void _onOkButtonTap() => Get.back();

  List<TextSpan> _message() => controller.getEnableLocationContent();

  Widget _primaryButton(BuildContext context) => PrimaryButton(
        onPressed:
            GetPlatform.isAndroid ? _onOkButtonTap : openSettingsButtonTap,
        text: _primaryButtonText,
      );

  CrossAxisAlignment getDialogCrossAxisAlignment() => CrossAxisAlignment.center;

  String get _primaryButtonText => GetPlatform.isAndroid
      ? ViewText.ok
      : SiteLocatorConstants.locationEnableDialogButtonText;

  void openSettingsButtonTap() {
    Get.back();
    AppSettings.openAppSettings();
  }
}
