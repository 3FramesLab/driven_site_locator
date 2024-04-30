part of map_view_module;

class FuelCardsController extends GetxController {
  late GetFuelCardsUseCase _fuelCardsUseCase;
  late AddFuelCardUseCase addFuelCardUseCase;
  late UpdateFuelCardUseCase updateFuelCardUseCase;

  RxList<FuelCard> cards = <FuelCard>[].obs;
  RxList<String> existingNickNames = <String>[].obs;
  FuelCard favoriteFuelCard = FuelCard();

  final cardTextEditController = TextEditingController();
  final nickNameEditController = TextEditingController();

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

  List<Validator> get validators => [
        const HasAtLeastNCharactersValidator(1),
        AlreadyInUseValidator(
          ViewText.cardNickname,
          existingNickNames,
        )
      ];

  @override
  Future<void> onInit() async {
    clearData();
    _initUseCases();
    await loadExistingCards();
    super.onInit();
  }

  void _initUseCases() {
    _fuelCardsUseCase = GetFuelCardsUseCase();
    addFuelCardUseCase = AddFuelCardUseCase();
    updateFuelCardUseCase = UpdateFuelCardUseCase();
  }

  Future<List<FuelCard>>? getFuelCardsList() async {
    cards.value = await _fuelCardsUseCase
        .execute(const GetFuelCardsParam(inOrdered: true));
    return cards();
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

  Future<void> cardSelected(FuelCard card) async {}

  void setUpFavorite() => isFavoriteCard(hasNoCards());

  void toggleSetAsFavorite() {
    if (hasCards()) {
      isFavoriteCard(!isFavoriteCard());
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

  void onNickNameTextChanged(String value) {
    final previousSelection = nickNameEditController.selection;
    nickNameEditController.text = value;
    nickNameEditController.selection = previousSelection;
    isValidNickname(_isValid(value));
    nickName(value);
  }

  bool _isValid(String value) => validators.every((v) => v.isValid(value));

  Future<void> loadExistingCards() async {
    final fuelCardsList = await getFuelCardsList();
    fuelCardsList?.forEach((e) {
      existingNickNames.add(e.cardNickName ?? '');
      if (e.isFavoriteCard == true) {
        favoriteFuelCard = e;
      }
    });
  }

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
      SiteLocatorNavigation.instance.addUnAuthorizeCard();
    } else {
      SiteLocatorNavigation.instance.fuelCardSelection();
    }
  }

  Future<void> onAddUnAuthorizedCardClicked() async {
    final fuelCard = FuelCard(
      cardNickName: nickName(),
      cardLastFourDigit: lastFourDigits(),
      isFavoriteCard: isFavoriteCard(),
    );
    await addFuelCardUseCase.execute(fuelCard);
    existingNickNames.add(nickName());
    cards.add(fuelCard);
    await _updateFavoriteCard(fuelCard);
    clearData();
    BaseDrivenFlashBar.show(
      message: ViewText.cardSavedSuccessfully,
      type: MessageType.success,
    );
  }

  Future<void> _updateFavoriteCard(FuelCard fuelCard) async {
    if (isFavoriteCard()) {
      favoriteFuelCard = fuelCard;
      for (final FuelCard card in cards()) {
        if (card.cardLastFourDigit == lastFourDigits()) {
          card.isFavoriteCard = true;
        } else {
          card.isFavoriteCard = false;
        }
        await updateFuelCardUseCase.execute(card);
      }
    }
  }

  void clearData() {
    cardNumber('');
    nickName('');
    canValidateForm(false);
    cardTextEditController.clear();
    nickNameEditController.clear();
    isValidNickname(false);
    isFavoriteCard(false);
  }

  String lastFourDigits() {
    if (cardNumber().length >= 4) {
      return cardNumber().substring(cardNumber().length - 4);
    }
    return '';
  }

  void onBackPressed() {
    canValidateForm(false);
    isOnBackPress(true);
    Get.back();
  }
}
