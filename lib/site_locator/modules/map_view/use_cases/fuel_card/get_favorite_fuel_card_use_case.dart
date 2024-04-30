import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/models/cards/fuel_card.dart';
import 'package:hive/hive.dart';

class GetFavoriteFuelCardUseCase extends BaseNoParamFutureUseCase<FuelCard?> {
  @override
  Future<FuelCard?> execute() async {
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    final cards = box.values.toList();

    final card = cards.firstWhere(
      (e) => e.isFavoriteCard ?? false,
      orElse: FuelCard.new,
    );
    return card.id == null ? null : card;
  }
}
