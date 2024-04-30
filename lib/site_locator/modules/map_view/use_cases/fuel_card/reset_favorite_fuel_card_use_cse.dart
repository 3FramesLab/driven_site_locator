import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/models/cards/fuel_card.dart';
import 'package:hive/hive.dart';

class ResetFavoriteFuelCardUseCase extends BaseFutureUseCase<void, FuelCard> {
  @override
  Future<void>? execute(FuelCard param) async {
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);
    param.isFavoriteCard = false;
    await box.put(param.id, param);
  }
}
