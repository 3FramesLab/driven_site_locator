import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/models/cards/fuel_card.dart';
import 'package:hive/hive.dart';

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
