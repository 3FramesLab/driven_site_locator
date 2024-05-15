part of map_view_module;

class UpdateFuelCardUseCase extends BaseFutureUseCase<bool, FuelCard> {
  final HiveInterface hive;

  UpdateFuelCardUseCase({required this.hive});

  @override
  Future<bool>? execute(FuelCard param) async {
    if (param.id == null) {
      return false;
    }
    final box = await hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    param.modifiedDate = DateTime.now().millisecondsSinceEpoch;
    await box.put(param.id, param);
    return true;
  }
}
