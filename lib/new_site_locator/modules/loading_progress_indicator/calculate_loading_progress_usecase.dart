part of loading_progress_indicator_module;

class CalculateSitesLoadingProgressUseCase
    extends BaseUseCase<double, CalculateSitesLoadingProgressParam> {
  @override
  double execute(CalculateSitesLoadingProgressParam param) {
    final previousValue = param.previousValue;
    final canShowLoading = param.canShowLoading;
    double resultValue = 0;
    if (previousValue > 0.9) {
      resultValue = previousValue;
    } else if (canShowLoading && previousValue < 0.6) {
      resultValue = previousValue + 0.05;
    } else if (canShowLoading && previousValue < 0.7) {
      resultValue = previousValue + 0.01;
    } else if (canShowLoading && previousValue < 0.8) {
      resultValue = previousValue + 0.03;
    } else {
      resultValue = previousValue + 0.03;
    }
    if (!canShowLoading) {
      resultValue = 0;
    }
    // print('debug-print: p = $previousValue, r = $resultValue');
    return resultValue;
  }
  // @override
  // double execute(CalculateSitesLoadingProgressParam param) {
  //   final previousValue = param.previousValue;
  //   final canShowLoading = param.canShowLoading;
  //   double resultValue = 0;
  //   if (previousValue > 97) {
  //     resultValue = previousValue;
  //   } else if (canShowLoading && previousValue < 60) {
  //     resultValue = previousValue + 1;
  //   } else if (canShowLoading && previousValue < 70) {
  //     resultValue = previousValue + 0.5;
  //   } else if (canShowLoading && previousValue < 80) {
  //     resultValue = previousValue + 3;
  //   } else {
  //     resultValue = canShowLoading ? previousValue + 1 : 0;
  //   }
  //   if (!canShowLoading) {
  //     resultValue = 0;
  //   }
  //   print('debug-print: p = $previousValue, r = $resultValue');
  //   return resultValue;
  // }
}

class CalculateSitesLoadingProgressParam {
  final double previousValue;
  final bool canShowLoading;

  CalculateSitesLoadingProgressParam({
    required this.previousValue,
    required this.canShowLoading,
  });
}
