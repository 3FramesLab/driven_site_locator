part of map_view_module;

class AddFuelCardUseCase extends BaseFutureUseCase<int, FuelCard> {
  final HiveInterface hive;

  AddFuelCardUseCase({required this.hive});

  @override
  Future<int> execute(FuelCard param) async {
    final box = await hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);

    final id = await _getIncrementId(box);

    param.id = id;
    param.createdDate = DateTime.now().millisecondsSinceEpoch;
    param.modifiedDate = DateTime.now().millisecondsSinceEpoch;

    await box.put(param.id, param);
    return id;
  }

  Future<int> _getIncrementId(Box<FuelCard> fuelCardBox) async {
    final cards = fuelCardBox.values.toList();
    if (cards.isEmpty) {
      return 1;
    }
    final ids = cards.map((e) => e.id).toList();

    final maxId = ids.reduce(
        (current, next) => (current ?? 0) > (next ?? 0) ? current : next);

    return (maxId ?? 0) + 1;
  }
}
