import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/models/cards/fuel_card.dart';
import 'package:hive/hive.dart';

class GetFuelCardsUseCase
    extends BaseFutureUseCase<List<FuelCard>, GetFuelCardsParam?> {
  @override
  Future<List<FuelCard>> execute(GetFuelCardsParam? param) async {
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
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
