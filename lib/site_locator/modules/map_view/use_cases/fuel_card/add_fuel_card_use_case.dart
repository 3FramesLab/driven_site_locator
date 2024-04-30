import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/models/cards/fuel_card.dart';
import 'package:hive/hive.dart';

class AddFuelCardUseCase extends BaseFutureUseCase<bool, FuelCard> {
  @override
  Future<bool> execute(FuelCard param) async {
    final box = await Hive.openBox<FuelCard>(SiteLocatorConstants.fuelCardBox);

    final id = await _getIncrementId(box);

    param.id = id;
    param.createdDate = DateTime.now().millisecondsSinceEpoch;
    param.modifiedDate = DateTime.now().millisecondsSinceEpoch;

    await box.put(param.id, param);
    return true;
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
