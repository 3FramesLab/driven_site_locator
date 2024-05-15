part of map_view_module;

class GetFavoriteFuelCardUseCase extends BaseNoParamFutureUseCase<FuelCard?> {
  final HiveInterface hive;

  GetFavoriteFuelCardUseCase({required this.hive});

  @override
  Future<FuelCard?> execute() async {
    final box = await hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    final cards = box.values.toList();

    final card = cards.firstWhere(
      (e) => e.isFavoriteCard ?? false,
      orElse: FuelCard.new,
    );
    return card.id == null ? null : card;
  }
}
