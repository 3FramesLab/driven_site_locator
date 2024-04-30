part of map_view_module;

class ResetFavoriteFuelCardUseCase extends BaseFutureUseCase<void, FuelCard> {
  @override
  Future<void>? execute(FuelCard param) async {
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    param.isFavoriteCard = false;
    await box.put(param.id, param);
  }
}
