// To parse this JSON data, do
//
//     final siteLocation = siteLocationFromJson(jsonString);

// ignore_for_file: must_be_immutable

part of map_view_module;

class MerchSiteResponse extends Decodable<MerchSiteResponse> {
  final String? sysAccountId;
  final String? fleetId;
  final String? cardToken;
  final List<SiteLocation>? siteLocations;

  MerchSiteResponse({
    this.sysAccountId,
    this.fleetId,
    this.cardToken,
    this.siteLocations,
  });

  factory MerchSiteResponse.fromJson(Map<String, dynamic> json) =>
      MerchSiteResponse(
        sysAccountId: json['sysAccountId'] ?? '',
        fleetId: json['fleetId'] ?? '',
        cardToken: json['cardToken'] ?? '',
        siteLocations: json['sites'] == null
            ? []
            : (json['sites'] as List)
                .map((e) => SiteLocation.fromJson(e))
                .toList(),
      );

  @override
  MerchSiteResponse decode(dynamic data) => MerchSiteResponse.fromJson(data);
}

class SiteLocation extends Decodable<List<SiteLocation>> with EquatableMixin {
  SiteLocation({
    this.masterIdentifier,
    this.productTypesAtSite,
    this.cardsAcceptedAtSite,
    this.amenities,
    this.brandName,
    this.fuelBrand,
    this.locationName,
    this.siteLatitude,
    this.siteLongitude,
    this.retailPriceGas,
    this.retailPriceDiesel,
    this.retailPriceCng,
    this.discountPriceGas,
    this.discountPriceDiesel,
    this.discountPriceCng,
    this.hours,
    this.locationStreetAddress,
    this.address2,
    this.locationCity,
    this.locationState,
    this.country,
    this.locationZip,
    this.locationPhone,
    this.primaryBusiness,
    this.ratings,
    this.placeId,
    this.newDiscountPriceDiesel, // only for guest
    //
    this.milesApart,
    this.milesApartFormatted,
    this.siteIdentifier,
    this.locationId,
    this.brandLogo,
    this.lastTrxDateFormatted,
    this.fuelTypes,
    this.locationType,
    this.paymentNetwork,
    this.services,
    this.dieselPrice,
    this.unleadedRegularPrice,
    this.unleadedPlusPrice,
    this.unleadedPremiumPrice,
    this.exit,
    this.highway,
    this.hoursOfOperation,
    this.dieselNet,
    this.dieselRetail,
    this.asOfDate,
    this.gasRetail,
    this.gasNet,
    this.gasAsOfDate,
    this.fuelPriceSourceEntity,
  });

  String? masterIdentifier; // siteNum
  String? productTypesAtSite;
  String? cardsAcceptedAtSite;
  String? amenities;
  String? brandName;
  String? fuelBrand; // brandName
  String? locationName; // siteName
  double? siteLatitude; // latitude
  double? siteLongitude; // longitude
  double? retailPriceGas;
  double? retailPriceDiesel;
  double? retailPriceCng;
  double? discountPriceGas;
  double? discountPriceDiesel;
  double? discountPriceCng;
  String? hours;
  String? locationStreetAddress; // address1
  String? address2;
  String? locationCity; // city
  String? locationState; // state
  String? country;
  String? locationZip; // postalCode
  String? locationPhone; // phoneNumber
  String? primaryBusiness;
  double? ratings;
  String? placeId;
  double? newDiscountPriceDiesel;

  double? milesApart;
  String? milesApartFormatted;
  String? siteIdentifier;
  int? locationId;
  String? brandLogo;
  String? lastTrxDateFormatted;
  FuelTypes? fuelTypes;
  LocationType? locationType;
  PaymentNetwork? paymentNetwork;
  Services? services;
  double? dieselPrice;
  double? unleadedRegularPrice;
  double? unleadedPlusPrice;
  double? unleadedPremiumPrice;

  //comdata
  String? hoursOfOperation;
  String? highway;
  String? exit;
  double? dieselRetail;
  double? dieselNet;
  String? asOfDate;

  // unleaded
  double? gasRetail;
  double? gasNet;
  String? gasAsOfDate;

  FuelPrices? fuelPriceSourceEntity;

  /// Whatever changes made in fromJson should also refactor in toJson
  factory SiteLocation.fromJson(Map<String, dynamic> json) => SiteLocation(
        masterIdentifier: json['siteNum'],
        productTypesAtSite: json['productTypesAtSite'] ?? '',
        cardsAcceptedAtSite: json['cardsAcceptedAtSite'] ?? '',
        amenities: json['amenities'] ?? '',
        brandName: json['brandName'],
        fuelBrand: json['brandName'],
        locationName: json['siteName'],
        siteLatitude: _tryParseCoordinates(json['latitude']),
        siteLongitude: _tryParseCoordinates(json['longitude']),
        retailPriceGas: _getPrice(json['retailPriceGas']),
        retailPriceDiesel: _getPrice(json['retailPriceDiesel']),
        retailPriceCng: _getPrice(json['retailPriceCng']),
        discountPriceGas: _getPrice(json['discountPriceGas']),
        discountPriceDiesel: _getPrice(json['discountPriceDiesel']),
        discountPriceCng: _getPrice(json['discountPriceCng']),
        // retailPriceGas: 2.19,
        // retailPriceDiesel: 2.15,
        // retailPriceCng: 4.10,
        // discountPriceGas: 2.14,
        // discountPriceDiesel: 2.10,
        // discountPriceCng: 2.10,
        hours: json['hours'],
        hoursOfOperation: json['hours'],
        locationStreetAddress: json['address1'],
        address2: json['address2'] ?? '',
        locationCity: json['city'],
        locationState: json['state'],
        country: json['country'],
        locationZip: json['postalCode'],
        locationPhone: json['phoneNumber'],
        primaryBusiness: json['primaryBusiness'],
        // ratings: DcSiteLocatorUtils.shouldInvokeGoogleRatingApi()
        //     ? null
        //     : DcSiteLocatorUtils.generateRandomDouble(),

        // TODO(Smeet): KEEP IT COMMENTED UNTIL WE GET TIME TO REFACTOR
        // brandName: json['brandName'],
        // locationName: json['locationName'],
        // locationStreetAddress: json['locationStreetAddress'],
        // locationCity: json['locationCity'],
        // locationState: json['locationState'],
        // locationZip: json['locationZip'],
        // locationPhone: json['locationPhone'],
        // siteLatitude: json['siteLatitude'].toDouble(),
        // siteLongitude: json['siteLongitude'].toDouble(),
        // milesApart: json['milesApart']?.toDouble(),
        // milesApartFormatted: json['milesApartFormatted'],
        // fuelBrand: AppUtils.replaceNullString(json['fuelBrand']),
        // siteIdentifier: json['siteIdentifier'],
        // locationId: json['locationId'],
        // brandLogo: _getBrandLogo(json),
        // // this `brandLogo` attribute is muted please do not use this
        // lastTrxDateFormatted: json['lastTrxdateFormatted'],
        // fuelTypes: json['fuelTypes'] != null
        //     ? FuelTypes.fromJson(json['fuelTypes'])
        //     : null,
        // locationType: json['locationType'] != null
        //     ? LocationType.fromJson(json['locationType'])
        //     : null,
        // paymentNetwork: json['paymentNetwork'] != null
        //     ? PaymentNetwork.fromJson(json['paymentNetwork'])
        //     : null,
        // services: json['services'] != null
        //     ? Services.fromJson(json['services'])
        //     : null,
        // dieselPrice: json['dieselPrice'],
        // unleadedRegularPrice: json['unleadedRegularPrice'],
        // unleadedPremiumPrice: json['unleadedPremiumPrice'],
        // unleadedPlusPrice: json['unleadedPlusPrice'],
        // //comdata
        // highway: AppUtils.replaceNullString(json['highway']),
        // exit: AppUtils.replaceNullString(json['exit']),
        // hoursOfOperation: json['hoursOfOperation'],
        // dieselNet: json['dieselNet'],
        // dieselRetail: json['dieselRetail'],
        // asOfDate: json['asOfDate'],

        // gasRetail: json['gasRetail'],
        // gasNet: json['gasNet'],
        // gasAsOfDate: json['gasAsOfDate'],

        // fuelPriceSourceEntity:
        //     FuelPrices.fromJson(SiteLocatorApiConstants.fuelPriceJsonTemplate),
      );

  static double _getPrice(String? price) {
    return double.parse(
        (double.tryParse(price ?? '') ?? 0.0).toStringAsFixed(2));
  }

  static double? _tryParseCoordinates(String? coordinate) {
    return double.tryParse(coordinate ?? '');
  }

  // static String? _getBrandLogo(Map<String, dynamic> json) =>
  //     json['brandLogo'] == 'null' ? null : json['brandLogo'];

  factory SiteLocation.blank() => SiteLocation();

  @override
  List<SiteLocation> decode(dynamic data) {
    final siteList = <SiteLocation>[];
    if (data.isNotEmpty) {
      for (final element in data) {
        siteList.add(SiteLocation.fromJson(element));
      }
    }
    return siteList;
  }

  Map<String, dynamic> toJson() => {
        'masterIdentifier': masterIdentifier,
        'brandName': brandName,
        'locationName': locationName,
        'locationStreetAddress': locationStreetAddress,
        'locationCity': locationCity,
        'locationState': locationState,
        'locationZip': locationZip,
        'locationPhone': locationPhone,
        'siteLatitude': siteLatitude,
        'siteLongitude': siteLongitude,
        'milesApart': milesApart,
        'milesApartFormatted': milesApartFormatted,
        'fuelBrand': fuelBrand,
        'siteIdentifier': siteIdentifier,
        'locationId': locationId,
        'brandLogo': brandLogo ?? 'null',
        'lastTrxdateFormatted': lastTrxDateFormatted,
        'fuelTypes': fuelTypes?.toJson(),
        'locationType': locationType?.toJson(),
        'paymentNetwork': paymentNetwork?.toJson(),
        'services': services?.toJson(),
        'dieselPrice': dieselPrice,
        'unleadedRegularPrice': unleadedRegularPrice,
        'unleadedPremiumPrice': unleadedPremiumPrice,
        'unleadedPlusPrice': unleadedPlusPrice,
        'highway': highway,
        'exit': exit,
        'hoursOfOperation': hoursOfOperation,
        'dieselNet': dieselNet,
        'dieselRetail': dieselRetail,
        'asOfDate': asOfDate,
        'gasRetail': gasRetail,
        'gasNet': gasNet,
        'gasAsOfDate': gasAsOfDate,
        'fuelPriceSourceEntity': fuelPriceSourceEntity?.toJson(),
      };

  factory SiteLocation.clone(SiteLocation siteLocation) => SiteLocation(
        masterIdentifier: siteLocation.masterIdentifier,
        productTypesAtSite: siteLocation.productTypesAtSite,
        cardsAcceptedAtSite: siteLocation.cardsAcceptedAtSite,
        amenities: siteLocation.amenities,
        brandName: siteLocation.brandName,
        fuelBrand: siteLocation.fuelBrand,
        locationName: siteLocation.locationName,
        siteLatitude: siteLocation.siteLatitude,
        siteLongitude: siteLocation.siteLongitude,
        retailPriceGas: siteLocation.retailPriceGas,
        retailPriceDiesel: siteLocation.retailPriceDiesel,
        retailPriceCng: siteLocation.retailPriceCng,
        discountPriceGas: siteLocation.discountPriceGas,
        discountPriceDiesel: siteLocation.discountPriceDiesel,
        discountPriceCng: siteLocation.discountPriceCng,
        hours: siteLocation.hours,
        locationStreetAddress: siteLocation.locationStreetAddress,
        address2: siteLocation.address2,
        locationCity: siteLocation.locationCity,
        locationState: siteLocation.locationState,
        country: siteLocation.country,
        locationZip: siteLocation.locationZip,
        locationPhone: siteLocation.locationPhone,
        primaryBusiness: siteLocation.primaryBusiness,
        ratings: siteLocation.ratings,
        placeId: siteLocation.placeId,
        hoursOfOperation: siteLocation.hoursOfOperation,
        newDiscountPriceDiesel: siteLocation.newDiscountPriceDiesel,
        //

        // milesApart: siteLocation.milesApart,
        // milesApartFormatted: siteLocation.milesApartFormatted,
        // siteIdentifier: siteLocation.siteIdentifier,
        // locationId: siteLocation.locationId,
        // brandLogo: siteLocation.brandLogo,
        // lastTrxDateFormatted: siteLocation.lastTrxDateFormatted,
        // fuelTypes: siteLocation.fuelTypes,
        // locationType: siteLocation.locationType,
        // paymentNetwork: siteLocation.paymentNetwork,
        // services: siteLocation.services,
        // dieselPrice: siteLocation.dieselPrice,
        // unleadedRegularPrice: siteLocation.unleadedRegularPrice,
        // unleadedPlusPrice: siteLocation.unleadedPlusPrice,
        // unleadedPremiumPrice: siteLocation.unleadedPremiumPrice,
        // exit: siteLocation.exit,
        // highway: siteLocation.highway,
        // dieselNet: siteLocation.dieselNet,
        // dieselRetail: siteLocation.dieselRetail,
        // asOfDate: siteLocation.asOfDate,
        // gasNet: siteLocation.gasNet,
        // gasRetail: siteLocation.gasRetail,
        // gasAsOfDate: siteLocation.gasAsOfDate,
        // fuelPriceSourceEntity: siteLocation.fuelPriceSourceEntity,
      );

  @override
  List<Object?> get props => [masterIdentifier];
}

class FuelTypes {
  FuelTypes({
    this.unleadedRegular,
    this.unleadedPlus,
    this.unleadedPremium,
    this.diesel,
  });

  Status? unleadedRegular;
  Status? unleadedPlus;
  Status? unleadedPremium;
  Status? diesel;

  /// Whatever changes made in fromJson should also refactor in toJson
  factory FuelTypes.fromJson(Map<String, dynamic> json) => FuelTypes(
        unleadedRegular: statusValues.map[json['unleadedRegular']],
        unleadedPlus: statusValues.map[json['unleadedPlus']],
        unleadedPremium: statusValues.map[json['unleadedPremium']],
        diesel:
            json['diesel'] == null ? null : statusValues.map[json['diesel']],
      );

  Map<String, dynamic> toJson() => {
        'unleadedRegular': unleadedRegular?.value,
        'unleadedPlus': unleadedPlus?.value,
        'unleadedPremium': unleadedPremium?.value,
        'diesel': diesel?.value,
      };
}

enum Status {
  Y('Y'),
  N('N');

  const Status(this.value);

  final String value;
}

final statusValues = EnumValues({'N': Status.N, 'Y': Status.Y});

class LocationType {
  LocationType({
    this.fmDiscountNetwork,
    this.mcDiscountNetwork,
    this.fuelStation,
    this.maintenanceService,
    this.gallonUp,
    this.lumperServices,
    this.truckStop,
  });

  Status? fmDiscountNetwork;
  Status? mcDiscountNetwork;
  Status? fuelStation;
  Status? maintenanceService;

  //comdata
  Status? lumperServices;
  Status? truckStop;
  Status? gallonUp;

  /// Whatever changes made in fromJson should also refactor in toJson
  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
        fmDiscountNetwork: nullCheckerForStatus(json['fmDiscountNetwork']),
        mcDiscountNetwork: nullCheckerForStatus(json['mcDiscountNetwork']),
        fuelStation: nullCheckerForStatus(json['fuelStation']),
        maintenanceService: nullCheckerForStatus(json['maintenanceService']),
        lumperServices: nullCheckerForStatus(json['lumperServices']),
        truckStop: nullCheckerForStatus(json['truckStop']),
        gallonUp: nullCheckerForStatus(json['gallonUp']),
      );

  Map<String, dynamic> toJson() => {
        'fmDiscountNetwork': fmDiscountNetwork?.value,
        'mcDiscountNetwork': mcDiscountNetwork?.value,
        'fuelStation': fuelStation?.value,
        'maintenanceService': maintenanceService?.value,
        'lumperServices': lumperServices?.value,
        'truckStop': truckStop?.value,
        'gallonUp': gallonUp?.value,
      };

  static dynamic nullCheckerForStatus(dynamic fieldValue) =>
      fieldValue == null ? null : statusValues.map[fieldValue];
}

class PaymentNetwork {
  PaymentNetwork({
    this.fuelmanPropriety,
    this.comdataPropriety,
  });

  Status? fuelmanPropriety;
  Status? comdataPropriety;

  /// Whatever changes made in fromJson should also refactor in toJson
  factory PaymentNetwork.fromJson(Map<String, dynamic> json) => PaymentNetwork(
        fuelmanPropriety: statusValues.map[json['fuelmanPropriety']],
        comdataPropriety: statusValues.map[json['comdataPropriety']],
      );

  Map<String, dynamic> toJson() => {
        'fuelmanPropriety': fuelmanPropriety?.value,
        'comdataPropriety': comdataPropriety?.value,
      };
}

class Services {
  Services({
    this.payAtPump,
    this.acceptGc,
    this.allowInStoreCards,
    this.atm,
    this.convStore,
    this.rigAccess,
    this.access18Wheeler,
    this.unattended,
    this.hwyAccess,
    this.tankReader,
    this.shower,
    this.truckStop,
    this.rigParking,
    this.restaurant,
    this.laundry,
    this.restaurant24Hr,
    this.lounge,
    this.motel,
    this.services24Hr,
    this.truckWash,
    this.scales,
    this.highSpeedPump,
    this.safeHaven,
    this.repairs,
    this.cashAdvance,
    this.deli,
    this.permits,
    this.gameRoom,
    this.truckersStore,
    this.tireRepair,
    this.wreckerService,
    this.fedex,
    this.ups,
  });

  Status? payAtPump;
  Status? acceptGc;
  Status? allowInStoreCards;
  Status? atm;
  Status? convStore;
  Status? rigAccess;
  Status? access18Wheeler;
  Status? unattended;
  Status? hwyAccess;
  Status? tankReader;
  Status? shower;
  Status? truckStop;
  Status? rigParking;
  Status? restaurant;
  Status? laundry;
  Status? restaurant24Hr;
  Status? lounge;
  Status? motel;
  Status? services24Hr;
  Status? truckWash;
  Status? scales;
  Status? highSpeedPump;

  //comdata
  Status? safeHaven;
  Status? repairs;
  Status? cashAdvance;
  Status? deli;
  Status? permits;
  Status? gameRoom;
  Status? truckersStore;
  Status? tireRepair;
  Status? wreckerService;
  Status? fedex;
  Status? ups;

  /// Whatever changes made in fromJson should also refactor in toJson
  factory Services.fromJson(Map<String, dynamic> json) => Services(
        payAtPump: nullCheckerForStatus(json['payAtPump']),
        acceptGc: nullCheckerForStatus(json['acceptGc']),
        allowInStoreCards: nullCheckerForStatus(json['allowInStoreCards']),
        atm: nullCheckerForStatus(json['atm']),
        convStore: nullCheckerForStatus(json['convStore']),
        rigAccess: nullCheckerForStatus(json['rigAccess']),
        access18Wheeler: nullCheckerForStatus(json['access18Wheeler']),
        unattended: nullCheckerForStatus(json['unattended']),
        hwyAccess: nullCheckerForStatus(json['hwyAccess']),
        tankReader: nullCheckerForStatus(json['tankReader']),
        shower: nullCheckerForStatus(json['shower']),
        truckStop: nullCheckerForStatus(json['truckStop']),
        rigParking: nullCheckerForStatus(json['rigParking']),
        restaurant: nullCheckerForStatus(json['restaurant']),
        laundry: nullCheckerForStatus(json['laundry']),
        restaurant24Hr: nullCheckerForStatus(json['restaurant24Hr']),
        lounge: nullCheckerForStatus(json['lounge']),
        motel: nullCheckerForStatus(json['motel']),
        services24Hr: nullCheckerForStatus(json['services24Hr']),
        truckWash: nullCheckerForStatus(json['truckWash']),
        scales: nullCheckerForStatus(json['scales']),
        highSpeedPump: nullCheckerForStatus(json['highSpeedPump']),
        safeHaven: nullCheckerForStatus(json['safeHaven']),
        repairs: nullCheckerForStatus(json['repairs']),
        cashAdvance: nullCheckerForStatus(json['cashAdvance']),
        deli: nullCheckerForStatus(json['deli']),
        permits: nullCheckerForStatus(json['permits']),
        gameRoom: nullCheckerForStatus(json['gameRoom']),
        truckersStore: nullCheckerForStatus(json['truckersStore']),
        tireRepair: nullCheckerForStatus(json['tireRepair']),
        wreckerService: nullCheckerForStatus(json['wreckerService']),
        fedex: nullCheckerForStatus(json['fedex']),
        ups: nullCheckerForStatus(json['ups']),
      );

  Map<String, String> toJson() {
    return {
      'payAtPump': getValueOfStatus(payAtPump),
      'acceptGc': getValueOfStatus(acceptGc),
      'allowInStoreCards': getValueOfStatus(allowInStoreCards),
      'atm': getValueOfStatus(atm),
      'convStore': getValueOfStatus(convStore),
      'rigAccess': getValueOfStatus(rigAccess),
      'access18Wheeler': getValueOfStatus(access18Wheeler),
      'unattended': getValueOfStatus(unattended),
      'hwyAccess': getValueOfStatus(hwyAccess),
      'tankReader': getValueOfStatus(tankReader),
      'shower': getValueOfStatus(shower),
      'truckStop': getValueOfStatus(truckStop),
      'rigParking': getValueOfStatus(rigParking),
      'restaurant': getValueOfStatus(restaurant),
      'laundry': getValueOfStatus(laundry),
      'restaurant24Hr': getValueOfStatus(restaurant24Hr),
      'lounge': getValueOfStatus(lounge),
      'motel': getValueOfStatus(motel),
      'services24Hr': getValueOfStatus(services24Hr),
      'truckWash': getValueOfStatus(truckWash),
      'scales': getValueOfStatus(scales),
      'highSpeedPump': getValueOfStatus(highSpeedPump),
      'safeHaven': getValueOfStatus(safeHaven),
      'repairs': getValueOfStatus(repairs),
      'cashAdvance': getValueOfStatus(cashAdvance),
      'deli': getValueOfStatus(deli),
      'permits': getValueOfStatus(permits),
      'gameRoom': getValueOfStatus(gameRoom),
      'truckersStore': getValueOfStatus(truckersStore),
      'tireRepair': getValueOfStatus(tireRepair),
      'wreckerService': getValueOfStatus(wreckerService),
      'fedex': getValueOfStatus(fedex),
      'ups': getValueOfStatus(ups),
    };
  }

  static String getValueOfStatus(Status? statusEnum) =>
      statusEnum == Status.Y ? Status.Y.name : Status.N.name;

  static dynamic nullCheckerForStatus(dynamic fieldValue) =>
      fieldValue == null ? null : statusValues.map[fieldValue];
}
