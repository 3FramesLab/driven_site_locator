import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class EnableLocationServiceDialog extends StatelessWidget {
  final Function()? onUseMyLocation;

  EnableLocationServiceDialog({required this.onUseMyLocation});

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: DrivenDialog(
        height: 100,
        width: 350,
        text: _message(),
        primaryButton: _primaryButton(context),
        // crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  void _onOkButtonTap() {
    Get.back();
  }

  List<TextSpan> _message() => siteLocatorController.getEnableLocationContent();

  Widget _primaryButton(BuildContext context) => PrimaryButton(
        onPressed: _onOkButtonTap,
        text: ViewText.ok,
      );
}
