part of map_view_module;

class FuelCardsController extends GetxController {
  late GetFuelCardsUseCase _fuelCardsUseCase;
  late AddFuelCardUseCase addFuelCardUseCase;
  late UpdateFuelCardUseCase updateFuelCardUseCase;
  late DeleteFuelCardUseCase deleteFuelCardUseCase;

  RxList<FuelCard> cards = <FuelCard>[].obs;
  RxList<String> existingNickNames = <String>[].obs;
  FuelCard favoriteFuelCard = FuelCard();
  Rx<FuelCard> editableFuelCard = FuelCard().obs;

  final cardTextEditController = TextEditingController();
  final nickNameEditController = TextEditingController();

  final HiveInterface hive = Hive;

  String initialNickNameValue = '';
  bool? initialFavoriteCardStatus;
  RxBool isAnyDataUpdated = false.obs;

  final cardNumber = ''.obs;
  final nickName = ''.obs;
  final isValidNickname = false.obs;
  final isFavoriteCard = false.obs;
  final showCardDetails = false.obs;
  final isDelete = false.obs;
  final canValidateForm = false.obs;
  final isOnBackPress = false.obs;
  final cardVisibility = false.obs;

  bool get canAddCard => isValidNickname() && isValidCardNumber();

  bool get canUpdateCard =>
      isAnyDataUpdated() &&
      isValidNickname() &&
      editableFuelCard().cardLastFourDigit != null;

  bool get isShowGreyCheckbox =>
      hasNoCards() || editableFuelCard().isFavoriteCard == true;

  @override
  Future<void> onInit() async {
    clearData();
    _initUseCases();
    await loadFuelCards();
    super.onInit();
  }

  void _initUseCases() {
    _fuelCardsUseCase = GetFuelCardsUseCase(hive: hive);
    addFuelCardUseCase = AddFuelCardUseCase(hive: hive);
    updateFuelCardUseCase = UpdateFuelCardUseCase(hive: hive);
    deleteFuelCardUseCase = DeleteFuelCardUseCase(hive: hive);
  }

  Future<void> loadFuelCards() async {
    cards.value = await _fuelCardsUseCase
        .execute(const GetFuelCardsParam(inOrdered: true));
    existingNickNames.clear();
    for (final card in cards()) {
      existingNickNames.add(card.cardNickName ?? '');
      if (card.isFavoriteCard == true) {
        favoriteFuelCard = card;
      }
    }
  }

  Future<void> deleteFuelCards(FuelCard fuelCard) async {
    await deleteFuelCardUseCase.execute(fuelCard.id!);
    await loadFuelCards();
    if (fuelCard.isFavoriteCard != null && fuelCard.isFavoriteCard!) {
      favoriteFuelCard.cardNickName = null;
      isFavoriteCard.value = false;
    }
  }

  bool hasCards() {
    return cards.isNotEmpty;
  }

  bool hasNoCards() {
    return cards.isEmpty;
  }

  bool hasOneCard() {
    return cards.length == 1;
  }

  bool hasAtLeastTwoCards() {
    return cards.length >= 2;
  }

  bool hasThreeCards() {
    return cards.length == 3;
  }

  bool hasTenCards() {
    return cards.length >= 10;
  }

  Future<void> cardSelected(FuelCard card) async {}

  void setUpFavorite() => isFavoriteCard(hasNoCards());

  void toggleSetAsFavorite() {
    if (hasCards() && editableFuelCard().isFavoriteCard != true) {
      isFavoriteCard(!isFavoriteCard());
      isAnyDataUpdated(initialFavoriteCardStatus != isFavoriteCard.value ||
          initialNickNameValue != nickNameEditController.text);
    }
  }

  void toggleCardVisibility() {
    if (cardVisibility()) {
      cardTextEditController.text =
          cardTextEditController.text.removeAllWhitespace;
      cardTextEditController.selection =
          TextSelection.collapsed(offset: cardTextEditController.text.length);
      cardVisibility(false);
    } else {
      cardTextEditController.text =
          formatCardStringValue(cardTextEditController.text);
      cardTextEditController.selection =
          TextSelection.collapsed(offset: cardTextEditController.text.length);
      cardVisibility(true);
    }
  }

  void toggleCardDetailVisibility() {
    showCardDetails(!showCardDetails());
  }

  void onNickNameTextChanged(String value, List<Validator> validators) {
    final previousSelection = nickNameEditController.selection;
    nickNameEditController.text = value;
    nickNameEditController.selection = previousSelection;
    isValidNickname(_isValid(value, validators));
    nickName(value);
    canValidateForm(true);
    isAnyDataUpdated(initialFavoriteCardStatus != isFavoriteCard.value ||
        initialNickNameValue != nickNameEditController.text);
  }

  bool _isValid(String value, List<Validator> validators) =>
      validators.every((v) => v.isValid(value));

  String formatCardStringValue(String value) {
    return value.removeAllWhitespace
        .replaceAllMapped(RegExp('.{4}'), (match) => '${match.group(0)} ')
        .trim();
  }

  void onVisibleTextChange(String value) {
    final previousSelection = cardTextEditController.selection;
    cardTextEditController.text = formatCardStringValue(value);
    cardTextEditController.selection =
        setTextSelection(previousSelection, value);
    cardNumber(value);
  }

  void onObscureTextChange(String value) {
    final previousSelection = cardTextEditController.selection;
    cardTextEditController.text = value;
    cardTextEditController.selection = previousSelection;
    cardNumber(value);
  }

  bool isValidCardNumber() {
    return cardNumber().removeAllWhitespace.length > 15 &&
        cardNumber().removeAllWhitespace.length < 25;
  }

  TextSelection setTextSelection(TextSelection selection, String value) {
    isDelete(value.removeAllWhitespace.length <
        cardNumber().removeAllWhitespace.length);
    if (selection.baseOffset % 5 == 0 && selection.baseOffset != 0) {
      return TextSelection.collapsed(
          offset:
              isDelete() ? selection.baseOffset - 1 : selection.baseOffset + 1);
    } else {
      return selection;
    }
  }

  void onAddCardClicked() {
    if (hasNoCards()) {
      SiteLocatorNavigation.instance.addFuelCard();
    } else {
      SiteLocatorNavigation.instance.fuelCardSelection();
    }
  }

  Future<void> onAddButtonClicked() async {
    final fuelCard = FuelCard(
      cardNickName: nickName(),
      cardLastFourDigit: lastFourDigits(),
      isFavoriteCard: isFavoriteCard(),
    );
    final cardId = await addFuelCardUseCase.execute(fuelCard);
    fuelCard.id = cardId;
    await _updateExistingFavoriteCard(fuelCard);
  }

  Future<void> onUpdateButtonClicked() async {
    editableFuelCard().cardNickName = nickNameEditController.text;
    editableFuelCard().isFavoriteCard = isFavoriteCard();
    await updateFuelCardUseCase.execute(editableFuelCard());
    await _updateExistingFavoriteCard(editableFuelCard());
  }

  Future<void> _updateExistingFavoriteCard(FuelCard fuelCard) async {
    if (isFavoriteCard() && hasCards()) {
      for (final card in cards()) {
        card.isFavoriteCard = false;
        await updateFuelCardUseCase.execute(card);
      }
      fuelCard.isFavoriteCard = true;
      await updateFuelCardUseCase.execute(fuelCard);
    }
    isOnBackPress(true);
    clearData();
    await loadFuelCards();
    Get.back();
  }

  void clearData() {
    cardNumber('');
    nickName('');
    canValidateForm(false);
    cardTextEditController.clear();
    nickNameEditController.clear();
    isValidNickname(false);
    isFavoriteCard(false);
    editableFuelCard(FuelCard());
  }

  String lastFourDigits() {
    if (cardNumber().length >= 4) {
      return cardNumber().substring(cardNumber().length - 4);
    }
    return '';
  }

  String get maskedCardNumber =>
      '•••• •••• •••• ${editableFuelCard().cardLastFourDigit ?? ''}';

  void onBackPressed() {
    canValidateForm(false);
    isOnBackPress(true);
    Get.back();
  }
}
