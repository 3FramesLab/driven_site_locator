// ignore_for_file: use_setters_to_change_properties

import 'package:driven/common/utilities/app_utils.dart';
import 'package:driven/common_modules/add_fuel_card/fuel_card_module.dart';
import 'package:driven/constants/enums/card_prod_type.dart';
import 'package:driven/constants/view_text.dart';
import 'package:driven_site_locator/use_cases/base_future_usecase.dart';
import 'package:driven/modules/wallet/controllers/wallet_controller.dart';
import 'package:driven/new_site_locator/modules/map_view/use_cases/mc_sites/mc_sites_governor.dart';
import 'package:driven/site_locator/configuration/site_locator_config.dart';
import 'package:driven/site_locator/constants/site_filter_keys_constants.dart';
import 'package:driven_site_locator/new_site_locator/config/z_sl_config_module.dart';
import 'package:get/get.dart';

class HasToSwitchMCTypeUseCase
    extends BaseFutureUseCase<bool, HasToSwitchMCTypeUseCaseParams> {
  HasToSwitchMCTypeUseCase();

  @override
  Future<bool> execute(HasToSwitchMCTypeUseCaseParams param) async {
    bool hasCards = false;
    bool isMasterCardSelected = false;
    if (!AppUtils.isComdata) {
      return false;
    }
    if (param.isUserAuthenticated) {
      Get.lazyPut(WalletController.new);
      final WalletController walletController = Get.find();
      hasCards = walletController.walletService.cards.isNotEmpty;
      if (hasCards) {
        isMasterCardSelected =
            walletController.walletService.activeCard.cardType ==
                CardProdType.mc;
      }
    } else {
      Get.lazyPut(FuelCardsController.new);
      final FuelCardsController fuelCardsController = Get.find();
      hasCards = fuelCardsController.hasCards();
      if (hasCards) {
        isMasterCardSelected =
            fuelCardsController.selectedfuelCard().cardProductType ==
                MCSitesGovernor.cardType;
      }
    }

    if (hasCards && isMasterCardSelected) {
      SiteLocatorConfig.quickFilterOptions
          .firstWhereOrNull((p) => p.key == QuickFilterKeys.masterCard)
          ?.isVisible = true;

      final isMasterQuickFilterSelected = MCSitesGovernor.isMCSitesViewEnabled;

      for (final item in SiteLocatorConfig.quickFilterOptions) {
        if (SLViewText.mcQuickFilterKeysList.contains(item.key) &&
            item.key != QuickFilterKeys.masterCard) {
          item.isVisible = isMasterQuickFilterSelected;
        } else if (SLViewText.mcExcludedQuickFilterKeysList
            .contains(item.key)) {
          item.isVisible = !isMasterQuickFilterSelected;
        }
      }
      SiteLocatorConfig.quickFilterOptions.refresh();
      return MCSitesGovernor.isMCSitesViewEnabled;
    } else {
      for (final item in SiteLocatorConfig.quickFilterOptions) {
        if (SLViewText.mcQuickFilterKeysList.contains(item.key)) {
          item.isVisible = false;
        } else if (SLViewText.mcExcludedQuickFilterKeysList
            .contains(item.key)) {
          item.isVisible = true;
        }
      }
      SiteLocatorConfig.quickFilterOptions.refresh();
      return false;
    }
  }
}

class HasToSwitchMCTypeUseCaseParams {
  final bool isUserAuthenticated;

  HasToSwitchMCTypeUseCaseParams({
    this.isUserAuthenticated = false,
  });
}
