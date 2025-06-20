import 'package:driven_common/common/driven_constants.dart';
import 'package:driven_site_locator/new_site_locator/models/cardholder_account_details_response.dart';

class CardTypeUtil {
  static CreditCardType getCardType(String? cardType) {
    return DrivenConstants.propCardTypes.contains(getCardProdType(cardType))
        ? CreditCardType.prop
        : DrivenConstants.onRoadCardTypes.contains(getCardProdType(cardType))
            ? CreditCardType.onroad
            : CreditCardType.none;
  }

  static CardProdType getCardProdType(String? cardType) {
    final cardProductType = cardType?.toString().toUpperCase();
    switch (cardProductType) {
      case 'OD':
        return CardProdType.od;
      case 'OE':
        return CardProdType.oe;
      case 'OM':
        return CardProdType.om;
      case 'OL':
        return CardProdType.ol;
      case 'PD':
        return CardProdType.pd;
      case 'PE':
        return CardProdType.pe;
      case 'PL':
        return CardProdType.pl;
      case 'PC':
        return CardProdType.pc;
      case 'CC':
        return CardProdType.cc;
      case 'MC':
        return CardProdType.mc;
      default:
        return CardProdType.none;
    }
  }
}
