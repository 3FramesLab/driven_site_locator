// To parse this JSON data, do
//
//     final siteLocation = siteLocationFromJson(jsonString);

import 'package:driven_common/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/data/models/enum_values.dart';

class SiteLocation extends Decodable<List<SiteLocation>> {
  SiteLocation({
    this.masterIdentifier,
    this.brandName,
    this.locationName,
    this.locationStreetAddress,
    this.locationCity,
    this.locationState,
    this.locationZip,
    this.locationPhone,
    this.siteLatitude,
    this.siteLongitude,
    this.milesApart,
    this.milesApartFormatted,
    this.fuelBrand,
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
  });

  String? masterIdentifier;
  String? brandName;
  String? locationName;
  String? locationStreetAddress;
  String? locationCity;
  String? locationState;
  String? locationZip;
  String? locationPhone;
  double? siteLatitude;
  double? siteLongitude;
  double? milesApart;
  String? milesApartFormatted;
  String? fuelBrand;
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

  /// Whatever changes made in fromJson should also refactor in toJson
  factory SiteLocation.fromJson(Map<String, dynamic> json) => SiteLocation(
        masterIdentifier: json['masterIdentifier'],
        brandName: json['brandName'],
        locationName: json['locationName'],
        locationStreetAddress: json['locationStreetAddress'],
        locationCity: json['locationCity'],
        locationState: json['locationState'],
        locationZip: json['locationZip'],
        locationPhone: json['locationPhone'],
        siteLatitude: json['siteLatitude'].toDouble(),
        siteLongitude: json['siteLongitude'].toDouble(),
        milesApart: json['milesApart'].toDouble(),
        milesApartFormatted: json['milesApartFormatted'],
        fuelBrand: AppUtils.replaceNullString(json['fuelBrand']),
        siteIdentifier: json['siteIdentifier'],
        locationId: json['locationId'],
        brandLogo: _getBrandLogo(
            json), // this `brandLogo` attribute is muted please do not use this
        lastTrxDateFormatted: json['lastTrxdateFormatted'],
        fuelTypes: json['fuelTypes'] != null
            ? FuelTypes.fromJson(json['fuelTypes'])
            : null,
        locationType: LocationType.fromJson(json['locationType']),
        paymentNetwork: PaymentNetwork.fromJson(json['paymentNetwork']),
        services: json['services'] == null
            ? null
            : Services.fromJson(json['services']),
        dieselPrice: json['dieselPrice'],
        unleadedRegularPrice: json['unleadedRegularPrice'],
        unleadedPremiumPrice: json['unleadedPremiumPrice'],
        unleadedPlusPrice: json['unleadedPlusPrice'],
        //comdata
        highway: AppUtils.replaceNullString(json['highway']),
        exit: AppUtils.replaceNullString(json['exit']),
        hoursOfOperation: json['hoursOfOperation'],
        dieselNet: json['dieselNet'],
        dieselRetail: json['dieselRetail'],
        asOfDate: json['asOfDate'],
      );

  static String? _getBrandLogo(Map<String, dynamic> json) =>
      json['brandLogo'] == 'null' ? null : json['brandLogo'];

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
      };
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
