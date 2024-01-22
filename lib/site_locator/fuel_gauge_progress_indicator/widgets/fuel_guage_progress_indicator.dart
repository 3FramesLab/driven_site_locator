import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/fuel_gauge_progress_indicator/controller/fuel_gauge_progress_controller.dart';
import 'package:driven_site_locator/site_locator/fuel_gauge_progress_indicator/fuel_gauge_dial_props.dart';
import 'package:driven_site_locator/site_locator/fuel_gauge_progress_indicator/widgets/fuel_gauge_progress_dial.dart';
import 'package:get/get.dart';

class FuelGuageProgressIndicator extends StatelessWidget {
  final FuelGaugeProgressController fgpController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: fgpController.progressValue() > 0
          ? _getFuelGuageProgressIndicator()
          : const SizedBox.shrink(),
    );
  }

  Widget _getFuelGuageProgressIndicator() {
    return Container(
      color: FuelGaugeProps.modalBgColor,
      padding: EdgeInsets.zero,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getFuelGauageProgressDial(),
          _getLoadingInfo(),
          _displayProgressValue(),
        ],
      ),
    );
  }

  Widget _getFuelGauageProgressDial() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      width: FuelGaugeProps.parentWidth,
      height: FuelGaugeProps.parentHeight,
      child: FuelGauageProgressDial(),
    );
  }

  Widget _getLoadingInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Obx(() => Text(
            fgpController.statusMessage(),
            style: FuelGaugeProps.loadingInfoStyle,
          )),
    );
  }

  Widget _displayProgressValue() {
    return Obx(() {
      final value = fgpController.progressValue();
      final progressPercentage =
          value > FuelGaugeProps.maxValue ? FuelGaugeProps.maxValue : value;
      return Text(
        '${progressPercentage.toInt()}%',
        style: FuelGaugeProps.loadingValueStyle,
      );
    });
  }
}
