part of search_location_module;

class SLSaveGooglePlacePredictionUseCase
    extends BaseFutureUseCase<bool, SaveGooglePlacePredictionParam> {
  final HiveInterface hive;

  SLSaveGooglePlacePredictionUseCase({required this.hive});

  @override
  Future<bool> execute(SaveGooglePlacePredictionParam param) async {
    try {
      final box = await hive.openBox<Predictions>(
        SLInternalText.predictionHiveBox,
      );

      final predictions = param.predictions;

      for (final prediction in predictions) {
        await box.put(prediction.placeId, prediction);
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}

class SaveGooglePlacePredictionParam {
  final List<Predictions> predictions;

  SaveGooglePlacePredictionParam({
    required this.predictions,
  });
}
