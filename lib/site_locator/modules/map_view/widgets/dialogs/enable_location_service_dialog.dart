import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class EnableLocationServiceDialog extends StatelessWidget {
  final Function()? onUseMyLocation;

  const EnableLocationServiceDialog({
    required this.onUseMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: DrivenDialog(
        height: 100,
        width: 350,
        text: _message(),
        primaryButton: _primaryButton(context),
        isDynamicAlert: true,
        secondaryButton: _secondaryRightButton(),
      ),
    );
  }

  Widget _secondaryRightButton() {
    const textStyle = TextStyle(
      fontSize: 14,
      fontWeight: DrivenFonts.fontWeightSemibold,
      color: Colors.black,
      decoration: TextDecoration.underline,
    );
    return TextButton(
      onPressed: _onCancelButtonTap,
      child: Text(
        SiteLocatorConstants.continueWithoutUsingMyLocation,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _onCancelButtonTap() {
    Get.back();
  }

  List<TextSpan> _message() => [
        const TextSpan(
          text: SiteLocatorConstants.useMyLocation,
        )
      ];

  Widget _primaryButton(BuildContext context) => PrimaryButton(
        onPressed: onUseMyLocation,
        text: SiteLocatorConstants.useMyLocationButton,
      );
}
