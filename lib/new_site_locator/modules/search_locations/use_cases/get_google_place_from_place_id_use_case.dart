part of search_location_module;

class GetGooglePlaceFromPlaceIdUseCase
    extends BaseNoParamFutureUseCase<List<Predictions>> {
  final HiveInterface hive;

  GetGooglePlaceFromPlaceIdUseCase({required this.hive});

  @override
  Future<List<Predictions>> execute() async {
    try {
      final box = await hive.openBox<Predictions>(
        DrivenConstants.predictionHiveBox,
      );

      final result = box.values.toList();

      result.sort((a, b) {
        return b.modifiedOn!.compareTo(a.modifiedOn!);
      });

      return result;
    } catch (_) {
      return [];
    }
  }
}
