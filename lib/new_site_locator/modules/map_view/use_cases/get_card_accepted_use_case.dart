part of map_view_module;

class GetCardAcceptedUseCase extends BaseUseCase<String, SiteLocation> {
  @override
  String execute(SiteLocation param) {
    final cardAccepted = param.cardsAcceptedAtSite;
    final resultBuffer = StringBuffer();

    if (cardAccepted.isNotNullEmptyOrWhitespace) {
      List<String> cardAcceptedList = cardAccepted!.split(',');

      if (cardAcceptedList.isNotEmpty) {
        cardAcceptedList = cardAcceptedList.map((e) => e.trim()).toList();
        for (final _cardAccepted in cardAcceptedList) {
          for (final cardTypeMapping in UmaSLProperties.cardTypeMapping) {
            if (_cardAccepted.toLowerCase() ==
                cardTypeMapping.merchSiteKey.toLowerCase()) {
              final guestKeys = cardTypeMapping.guestKeys;

              for (final guestKey in guestKeys) {
                resultBuffer.write('$guestKey, ');
              }
            }
          }
        }
      }
    }

    if (resultBuffer.isNotEmpty) {
      return resultBuffer.toString().substring(0, resultBuffer.length - 2);
    } else {
      return '';
    }
  }
}
