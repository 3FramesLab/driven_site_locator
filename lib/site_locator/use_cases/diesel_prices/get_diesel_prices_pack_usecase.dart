import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/manage_diesel_sale_type_usecase.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class DieselPricesPackUseCase
    extends BaseUseCase<DieselPricesPack, DieselPricesPackParam> {
  late SiteLocatorController siteLocatorController;
  late ManageDieselSaleTypeUseCase manageDieselSaleTypeUseCase;
  @override
  DieselPricesPack execute(DieselPricesPackParam param) {
    siteLocatorController = Get.find();
    manageDieselSaleTypeUseCase = Get.find();

    final siteLocation = param.siteLocation;
    final whichPrice = manageDieselSaleTypeUseCase.execute(param);
    final String netPrice = SiteInfoUtils.getDieselNetPrice(siteLocation);
    final String retailPrice = SiteInfoUtils.getDieselRetailPrice(siteLocation);
    String typeLabel = '';

    if (whichPrice == DieselPriceDisplay.both ||
        whichPrice == DieselPriceDisplay.netOnly) {
      typeLabel = SiteLocatorConstants.discountLabel;
    }
    if (whichPrice == DieselPriceDisplay.retailOnly) {
      typeLabel = SiteLocatorConstants.retailLabel;
    }

    return DieselPricesPack(
      whichPrice: whichPrice,
      netPrice: netPrice,
      retailPrice: retailPrice,
      typeLabel: typeLabel,
    );
  }
}

class DieselPricesPackParam {
  final SiteLocation siteLocation;
  final bool? hasUserAuthenticated;

  DieselPricesPackParam({
    required this.siteLocation,
    this.hasUserAuthenticated = false,
  });
}
