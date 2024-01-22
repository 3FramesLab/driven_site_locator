import 'package:driven_site_locator/data/use_cases/base_usecase.dart';

class CalculateFuelGaugeProgressUseCase
    extends BaseUseCase<double, CalculateFuelGaugeProgressParam> {
  @override
  double execute(CalculateFuelGaugeProgressParam param) {
    final previousValue = param.previousValue;
    final canShowLoading = param.canShowLoading;
    double resultValue = 0;
    if (previousValue > 97) {
      resultValue = previousValue;
    } else if (canShowLoading && previousValue < 60) {
      resultValue = previousValue + 5;
    } else if (canShowLoading && previousValue < 70) {
      resultValue = previousValue + 1;
    } else if (canShowLoading && previousValue < 80) {
      resultValue = previousValue + 0.5;
    } else {
      resultValue = canShowLoading ? previousValue + 0.1 : 0;
    }
    if (!canShowLoading) {
      resultValue = 0;
    }
    return resultValue;
  }
}

class CalculateFuelGaugeProgressParam {
  final double previousValue;
  final bool canShowLoading;

  CalculateFuelGaugeProgressParam({
    required this.previousValue,
    required this.canShowLoading,
  });
}
