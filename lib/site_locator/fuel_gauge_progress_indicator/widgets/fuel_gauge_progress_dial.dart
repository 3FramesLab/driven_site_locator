import 'package:driven_site_locator/site_locator/fuel_gauge_progress_indicator/controller/fuel_gauge_progress_controller.dart';
import 'package:driven_site_locator/site_locator/fuel_gauge_progress_indicator/fuel_gauge_dial_props.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:get/get.dart';

class FuelGauageProgressDial extends GetView<FuelGaugeProgressController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => _fuelGaugeContainer(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fuelGaugeContainer() {
    return Container(
      decoration: FuelGaugeProps.dialScaleBg,
      width: FuelGaugeProps.parentWidth,
      height: FuelGaugeProps.parentHeight,
      child: _fuelGaugeProgressDial(),
    );
  }

  Widget _fuelGaugeProgressDial() {
    return Container(
      padding: const EdgeInsets.only(left: 3, top: 2),
      child: Obx(
        () => AnimatedRadialGauge(
          radius: FuelGaugeProps.gaugeRadius,
          duration: const Duration(),
          curve: Curves.elasticOut,
          value: controller.progressValue(),
          axis: FuelGaugeProps.gaugeAxis,
        ),
      ),
    );
  }
}
