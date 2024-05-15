part of map_view_module;

// Pass Fuel Card ID
class DeleteFuelCardUseCase extends BaseFutureUseCase<void, int> {
  final HiveInterface hive;

  DeleteFuelCardUseCase({required this.hive});

  @override
  Future<void>? execute(int param) async {
    final box = await hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    await box.delete(param);
  }
}
