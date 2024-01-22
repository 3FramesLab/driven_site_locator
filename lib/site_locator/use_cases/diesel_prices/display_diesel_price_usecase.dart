import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_price_entity.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/get_diesel_prices_pack_usecase.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/manage_diesel_sale_type_usecase.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class DisplayDieselPriceUseCase
    extends BaseUseCase<DieselPriceEntity, DieselPricesPackParam> {
  late SiteLocatorController siteLocatorController;
  late ManageDieselSaleTypeUseCase manageDieselSaleTypeUseCase;
  @override
  DieselPriceEntity execute(DieselPricesPackParam param) {
    final siteLocation = param.siteLocation;
    siteLocatorController = Get.find();
    manageDieselSaleTypeUseCase = Get.find();

    final whichPrice = manageDieselSaleTypeUseCase.execute(param);
    final String netPrice = SiteInfoUtils.getDieselNetPrice(siteLocation);
    final String retailPrice = SiteInfoUtils.getDieselRetailPrice(siteLocation);
    String dispalyDieselPrice = '';
    String saleTypeLabel = '';
    double priceNumeric = 0;

    if (whichPrice == DieselPriceDisplay.both ||
        whichPrice == DieselPriceDisplay.netOnly) {
      saleTypeLabel = SiteLocatorConstants.discountLabel;
      dispalyDieselPrice = netPrice;
      priceNumeric = SiteInfoUtils.getDieselNetPriceNumeric(siteLocation);
    }
    if (whichPrice == DieselPriceDisplay.retailOnly) {
      saleTypeLabel = SiteLocatorConstants.retailLabel;
      dispalyDieselPrice = retailPrice;
      priceNumeric = SiteInfoUtils.getDieselRetailPriceNumeric(siteLocation);
    }

    return DieselPriceEntity(
      price: dispalyDieselPrice,
      saleType: saleTypeLabel,
      priceNumeric: priceNumeric,
    );
  }
}
