import 'package:driven_site_locator/constants/app_strings.dart';
import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:get/get.dart';

class PreferredSiteLocatorHomeScreenDialog extends StatelessWidget {
  const PreferredSiteLocatorHomeScreenDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: DrivenRectangleBorder.mediumRounded,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: SiteLocatorConstants.minLocationEnableDialogHeight,
        ),
        child: DrivenColumn(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.all(SiteLocatorDimensions.dp16),
          children: [
            _dialogPrimaryText(),
            const SizedBox(height: SiteLocatorDimensions.dp24),
            DialogButton(
              onPressed: _yesButtonTap,
              text: ViewText.yes,
              height: SiteLocatorDimensions.dp48,
            ),
            _noThanksButton(),
          ],
        ),
      ),
    );
  }

  void _yesButtonTap() {
    trackAction(
      AnalyticsTrackActionName.preferredHomeScreenYesButtonEvent,
    );
    // LocalStorageAdapter.setLocatorMapAsPreferredHomeScreen(AppStrings.trueText);
    DrivenSiteLocator.instance.setLocatorMapAsPreferredHomeScreen?.call(
      AppStrings.trueText,
    );
    Get.back();
  }

  Widget _noThanksButton() => UnderlinedButton.black(
        onPressed: () {
          trackAction(
            AnalyticsTrackActionName.preferredHomeScreenNoButtonEvent,
          );
          // LocalStorageAdapter.setLocatorMapAsPreferredHomeScreen(
          //     AppStrings.falseText);
          DrivenSiteLocator.instance.setLocatorMapAsPreferredHomeScreen?.call(
            AppStrings.falseText,
          );
          Get.back();
        },
        text: ViewText.noThanks,
      );

  Text _dialogPrimaryText() => const Text(
        SiteLocatorConstants.preferredHomeDialogText,
        textAlign: TextAlign.center,
        style: f16RegularBlack,
        overflow: TextOverflow.visible,
      );
}
