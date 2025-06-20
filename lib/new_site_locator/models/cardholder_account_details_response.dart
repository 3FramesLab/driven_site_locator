import 'package:driven_common/common/money_maker.dart';
import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/new_site_locator/utilities/card_type_util.dart';
import 'package:money2/money2.dart';

class CardholderAccountDetailsResponse
    implements Decodable<CardholderAccountDetailsResponse> {
  String? accountNumber;
  String? accountName;
  String? groupStatus;
  List<Cards>? cards;

  CardholderAccountDetailsResponse({
    this.accountNumber,
    this.accountName,
    this.groupStatus,
    this.cards,
  });

  CardholderAccountDetailsResponse.fromJson(Map<String, dynamic> json) {
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    groupStatus = json['groupStatus'];
    if (json['response'] != null) {
      cards = <Cards>[];
      json['response'].forEach((v) {
        cards!.add(Cards.fromJson(v));
      });
    }
  }

  @override
  CardholderAccountDetailsResponse decode(dynamic json) =>
      CardholderAccountDetailsResponse.fromJson(json);
}

class Cards {
  late final Money balance;
  final String cardNumberLastFourDigit;
  final bool inactive;
  final CreditCardType type;
  final CardProdType cardType;
  final String cardProdType;
  final String corpName;
  String nickname;
  final String accountCode;
  final String sysAccountId;
  final String customerId;
  final String altFundingFlag;
  final String cardToken;
  final String? primaryCard;
  bool primary;
  bool favorite;
  final bool isNull;
  final String autoLockCustEnrollStatus;
  final String autoLockCustUnLockDuration;
  final String autoLockLastUpdateDate;
  final String autoLockLastUpdateTime;
  final String remainingUnlockTime;
  final String autoLockCardLockStatus;
  final String eicConsentFlg;
  String? status; // MAPI
  final String? cardStatus; // JAPI
  final String? requestorType;
  final String? cardholderOnboardId;
  final String? fleetId;
  final String? lastName;
  final String? authCodeAcceptance;
  final String? accountName;
  final String? resellerId;

  Cards({
    int balance = 0,
    this.cardNumberLastFourDigit = '',
    this.nickname = '',
    this.accountCode = '',
    this.customerId = '',
    this.altFundingFlag = '',
    this.cardToken = '',
    this.cardProdType = '',
    this.corpName = '',
    this.sysAccountId = '',
    this.autoLockCustEnrollStatus = '',
    this.autoLockCustUnLockDuration = '',
    this.autoLockLastUpdateDate = '',
    this.autoLockLastUpdateTime = '',
    this.remainingUnlockTime = '',
    this.autoLockCardLockStatus = '',
    this.primaryCard,
    this.primary = false,
    this.favorite = false,
    this.inactive = false,
    this.type = CreditCardType.none,
    this.cardType = CardProdType.none,
    this.isNull = false,
    this.eicConsentFlg = '',
    this.status,
    this.cardStatus,
    this.requestorType = '',
    this.cardholderOnboardId,
    this.fleetId,
    this.lastName,
    this.authCodeAcceptance,
    this.accountName,
    this.resellerId,
  }) {
    this.balance = MoneyMaker.fromInt(balance);
  }

  Cards.fromJson(dynamic json)
      : balance = MoneyMaker.fromIconnect(json['cardBalance'] ?? '0'),
        cardNumberLastFourDigit =
            json['cardNumber'] ?? json['lastFourCardNumber'] ?? '',
        nickname = json['nickName'] ?? '',
        corpName = json['corpName'] ?? '',
        accountCode = json['accountCode'] ?? '',
        sysAccountId = json['sysAccountId'] ?? '',
        customerId = json['custID'] ?? '',
        altFundingFlag = json['altFundingFlag'] ?? '',
        cardToken = json['cardToken'] ?? '',
        cardProdType = json['cardProdType'] ?? '',
        primaryCard = json['primaryCard'] ?? '',
        primary = json['primaryCard'] == 'Y',
        favorite = json['favoriteCard'] == 'Y',
        inactive = json['status'] != ViewText.activeCardStatus,
        type = CardTypeUtil.getCardType(json['cardProdType'] ?? ''),
        cardType = CardTypeUtil.getCardProdType(
            json['cardProdType'] ?? json['cardType'] ?? ''),
        autoLockCustEnrollStatus = json['autoLockCustEnrollStatus'] ?? '',
        autoLockCustUnLockDuration = json['autoLockCustUnLockDuration'] ?? '',
        autoLockLastUpdateDate = json['autoLockLastUpdateDate'] ?? '',
        autoLockLastUpdateTime = json['autoLockLastUpdateTime'] ?? '',
        remainingUnlockTime = json['remainingUnlockTime'] ?? '',
        autoLockCardLockStatus = json['autoLockCardLockStatus'] ?? '',
        eicConsentFlg = json['eicConsentFlg'] ?? '',
        status = json['status'],
        cardStatus = json['cardStatus'],
        lastName = json['lastName'],
        requestorType = json['requestorType'] ?? '',
        cardholderOnboardId = json['cardholderOnboardId'].toString(),
        fleetId = json['fleetId'],
        authCodeAcceptance = json['authCodeAcceptance'] ?? '',
        accountName = json['accountName'] ?? '',
        resellerId = json['resellerId'] ?? '',
        isNull = false;

  static Cards nullObject() {
    return Cards(
      isNull: true,
    );
  }
}

enum CardProdType {
  od('OD'),
  oe('OE'),
  om('OM'),
  ol('OL'),
  pd('PD'),
  pe('PE'),
  pl('PL'),
  pc('PC'),
  cc('CC'),
  mc('MC'),
  none('NONE');

  final String name;
  const CardProdType(this.name);
}

enum CreditCardType {
  onroad,
  prop,
  none,
}
