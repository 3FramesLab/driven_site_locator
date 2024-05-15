part of map_view_module;

class ResetFavoriteFuelCardUseCase extends BaseFutureUseCase<void, FuelCard> {
  final HiveInterface hive;

  ResetFavoriteFuelCardUseCase({required this.hive});

  @override
  Future<void>? execute(FuelCard param) async {
    final box = await hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    param.isFavoriteCard = false;
    await box.put(param.id, param);
  }
}
