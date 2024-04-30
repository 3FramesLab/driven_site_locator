part of map_view_module;

class UpdateFuelCardUseCase extends BaseFutureUseCase<bool, FuelCard> {
  @override
  Future<bool>? execute(FuelCard param) async {
    if (param.id == null) {
      return false;
    }
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    param.modifiedDate = DateTime.now().millisecondsSinceEpoch;
    await box.put(param.id, param);
    return true;
  }
}
