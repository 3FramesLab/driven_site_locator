part of select_your_card_module;

class SelectYourCardController extends GetxController {
  Rxn<CardTypeModel?> selectedCardType = Rxn<CardTypeModel?>();

  final cardTypeForMerchSitesUseCase = GetCardTypeForMerchSitesUseCase();

  @override
  void onInit() {
    super.onInit();
    initCardType();
  }

  void initCardType() {
    for (final cardType in cardTypes()) {
      final finder = '${cardType.title} - ${cardType.subtitle}'.trim();
      final response = cardTypeForMerchSitesUseCase.execute(finder);
      cardType.key = response.key;
      cardType.fuelType = response.fuelType;
    }
    cardTypes.refresh();
  }

  void onCardDetailTap(CardTypeModel cardType) {
    if (Get.currentRoute == SLRoutes.unauthSiteLocator) {
      if (selectedCardType.value != cardType) {
        selectedCardType(cardType);
      } else {
        selectedCardType.value = null;
      }
      Get.back();
      callMerchSitesOnFilter();
    } else {
      selectedCardType(cardType);
    }
  }

  Future<void> callMerchSitesOnFilter() async {
    await DcSiteLocatorUtils.callMerchSitesOnFilterChange(
      cardType: selectedCardType(),
    );
  }

  bool isAnyCardSelected() => selectedCardType.value != null;

  CardTypeModel getCardDetail(String key) =>
      cardTypes().firstWhere((element) => element.key == key);

  void onContinueToMapClick() {
    slNavTo.offUnauthSL();
  }

  // displayed on SL header, along with back button
  String get headerValue {
    if (selectedCardType() == null) {
      return '';
    } else {
      return '${selectedCardType()?.title}: ${selectedCardType()?.subtitle}';
    }
  }

  final RxList<CardTypeModel> cardTypes = <CardTypeModel>[
    CardTypeModel(
      key: '',
      title: SLViewText.fuelman,
      subtitle: SLViewText.fleetCardType,
      cards: const [SLAssets.fuelmanFleetCard],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.fuelman,
      subtitle: SLViewText.masterCard,
      cards: const [SLAssets.fuelmanMasterCard],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.fuelmanDual,
      subtitle: SLViewText.masterCardFleetId,
      cards: const [SLAssets.fuelmanDualMastercardFleetCard],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.comdataCardType,
      subtitle: SLViewText.fleetCardType,
      cards: const [SLAssets.comdataFleeCard],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.comdataCardType,
      subtitle: SLViewText.connectCardType,
      cards: const [SLAssets.comdataConnectCard],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.comdataCardType,
      subtitle: SLViewText.masterCard,
      cards: const [SLAssets.comdataMastercard],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.comdataCardType,
      subtitle: SLViewText.onRoadCardType,
      cards: const [SLAssets.comdataOnroad],
    ),
    CardTypeModel(
      key: '',
      title: SLViewText.comdataCardType,
      subtitle: SLViewText.masterCardFleetId,
      cards: const [SLAssets.comdataMastercardFleetCard],
    ),
  ].obs;
}
