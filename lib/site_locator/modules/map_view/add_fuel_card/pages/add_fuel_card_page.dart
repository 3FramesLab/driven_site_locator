import 'package:driven_common/driven_components/text_widgets/view_large_title.dart';
import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/add_fuel_card_form.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/fuel_card_favorite_checkbox.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/fuel_card/add_fuel_card_use_case.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/fuel_card/get_fuel_cards_use_case.dart';
import 'package:get/get.dart';

class AddFuelCardPage extends StatelessWidget {
  final FuelCardsController controller = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();
  final AddFuelCardUseCase addFuelCardUseCase = AddFuelCardUseCase();
  final GetFuelCardsUseCase getFuelCardsUseCase = GetFuelCardsUseCase();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.clearData();
      controller.setUpFavorite();
      controller.isOnBackPress(false);
    });
    return BaseDrivenScaffold(
      disableBack: true,
      goesInactive: siteLocatorController.isUserAuthenticated,
      isInactivityWrapperActivated:
          DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
      onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
      appBar: DrivenAppBar(
        leading: DrivenBackButton(onPressed: controller.onBackPressed),
      ),
      body: PageContent(
        leading: const [ViewLargeTitle(title: ViewText.addNewCardUnAuthorized)],
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(),
              const SizedBox(height: 25),
              AddFuelCardForm(),
              const SizedBox(height: 20),
              FuelCardFavoriteCheckbox(),
              const SizedBox(height: 35),
              _addCardButton()
            ],
          ),
        ),
      ),
    );
  }

  Row _subTitle() {
    return Row(
      children: const [
        SubTitleText(
          title: ViewText.pleaseEnterCardNumberNickname,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _addCardButton() {
    return Obx(
      () => PrimaryButton(
        onPressed: controller.canAddCard
            ? controller.onAddUnAuthorizedCardClicked
            : null,
        text: ViewText.addCard,
      ),
    );
  }
}
