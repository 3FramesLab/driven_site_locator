part of map_view_module;

// Pass Fuel Card ID
class DeleteFuelCardUseCase extends BaseFutureUseCase<void, int> {
  @override
  Future<void>? execute(int param) async {
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    await box.delete(param);
  }
}
