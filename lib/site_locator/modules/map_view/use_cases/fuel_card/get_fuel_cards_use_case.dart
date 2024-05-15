part of map_view_module;

class GetFuelCardsUseCase
    extends BaseFutureUseCase<List<FuelCard>, GetFuelCardsParam?> {
  final HiveInterface hive;

  GetFuelCardsUseCase({required this.hive});

  @override
  Future<List<FuelCard>> execute(GetFuelCardsParam? param) async {
    final box = await hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    final unorderedCards = box.values.toList();
    if (param?.inOrdered ?? false) {
      unorderedCards.sort((a, b) {
        // Priority 1 - sort by favorite
        final sortByFavorite = a.isFavoriteCard == b.isFavoriteCard
            ? 0
            : ((a.isFavoriteCard ?? false) ? -1 : 1);

        // Priority 2 - sort by modified date
        if (sortByFavorite == 0) {
          return (b.createdDate ?? 0).compareTo(a.createdDate ?? 0);
        }
        return sortByFavorite;
      });
    }
    return unorderedCards;
  }
}

class GetFuelCardsParam {
  final bool inOrdered;

  const GetFuelCardsParam({required this.inOrdered});
}
