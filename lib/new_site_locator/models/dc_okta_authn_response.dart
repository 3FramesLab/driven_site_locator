import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/new_site_locator/models/admin_account_detail_response.dart';

class DcOktaAuthnResponse implements Decodable<DcOktaAuthnResponse> {
  String? status;
  String? statusCode;
  String? stateToken;
  String? xDeviceToken;
  String? refreshToken;
  String? accessToken;
  String? pwaAccessToken;
  DCOktaUser? user;
  List<Factor>? factors;
  DefaultProperties? defaultProperties;

  DcOktaAuthnResponse({
    this.status,
    this.statusCode,
    this.stateToken,
    this.xDeviceToken,
    this.refreshToken,
    this.accessToken,
    this.pwaAccessToken,
    this.user,
    this.factors,
    this.defaultProperties,
  });

  @override
  DcOktaAuthnResponse decode(dynamic json) =>
      DcOktaAuthnResponse.fromJson(json);

  DcOktaAuthnResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    statusCode = json['statusCode'] ?? '';
    stateToken = json['stateToken'] ?? '';
    xDeviceToken = json['xDeviceToken'] ?? '';
    accessToken = json['accessToken'] ?? '';
    refreshToken = json['refreshToken'] ?? '';
    pwaAccessToken = json['pwaAccessToken'] ?? '';
    user = json['user'] != null ? DCOktaUser.fromJson(json['user']) : null;
    if (json['factors'] != null && json['factors'] is List) {
      factors = <Factor>[];
      json['factors'].forEach((v) {
        factors!.add(Factor.fromJson(v));
      });
    }
    if (json['defaultProperties'] != null) {
      defaultProperties = DefaultProperties.fromJson(json['defaultProperties']);
    }
  }
}

class DCOktaUser {
  String? id;
  String? role;
  int? roleId;
  String? sysAccountId;
  String? culture;
  bool? hostFleetnet;
  bool? hostMainframe;
  bool? hostIfleet;
  String? mddbUserId;

  Profile? profile;
  List<AdminAccountDetailResponse>? accountDetails;

  DCOktaUser({
    this.id,
    this.role,
    this.roleId,
    this.sysAccountId,
    this.culture,
    this.hostFleetnet,
    this.hostMainframe,
    this.hostIfleet,
    this.mddbUserId,
    this.profile,
    this.accountDetails = const [],
  });

  DCOktaUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    role = json['role'] ?? '';
    roleId = json['roleId'] ?? 840;
    sysAccountId = json['sysAccountId'] ?? '';
    culture = json['culture'] ?? 'en-US';
    hostFleetnet = json['hostFleetnet'] == 'Y';
    hostMainframe = json['hostMainframe'] == 'Y';
    hostIfleet = json['hostIfleet'] == 'Y';
    mddbUserId = json['mddbUserId'] ?? '';
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    accountDetails = getAccountDetails(json);
  }

  static List<AdminAccountDetailResponse>? getAccountDetails(
      Map<String, dynamic> json) {
    final List<AdminAccountDetailResponse> accountList = [];
    final list = (json['userAccountDetails'] ?? []) as List;
    for (final account in list) {
      accountList.add(AdminAccountDetailResponse.fromJson(account));
    }
    return accountList;
  }
}

class Factor {
  String? factorId;
  String? factorType;
  String? status;
  String? provider;
  String? vendorName;
  FactorProfile? profile;

  Factor({
    this.factorId,
    this.factorType,
    this.status,
    this.provider,
    this.vendorName,
    this.profile,
  });

  factory Factor.fromJson(Map<String, dynamic> json) => Factor(
        factorId: json['id'],
        factorType: json['factorType'],
        provider: json['provider'],
        vendorName: json['vendorName'],
        status: json['status'],
        profile: getFactorProfile(json),
      );

  static FactorProfile? getFactorProfile(Map<String, dynamic> json) {
    return json['profile'] != null
        ? FactorProfile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = factorId;
    data['factorType'] = factorType;
    data['provider'] = provider;
    data['vendorName'] = vendorName;
    data['status'] = status;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? login;
  String? firstName;
  String? lastName;
  String? mobileNumber;

  Profile({
    this.login,
    this.firstName,
    this.lastName,
    this.mobileNumber,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    login = json['login'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    mobileNumber = json['mobileNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobilePhone'] = mobileNumber;
    data['login'] = login;
    data['email'] = login;
    return data;
  }

  Profile copyWith({
    String? login,
    String? firstName,
    String? lastName,
    String? mobileNumber,
  }) {
    return Profile(
      login: login ?? this.login,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}

class FactorProfile {
  FactorProfile({
    this.email,
    this.phone,
  });

  String? email;
  String? phone;

  factory FactorProfile.fromJson(Map<String, dynamic> json) => FactorProfile(
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class DefaultProperties {
  String? fleetId;
  String? fleetName;
  String? accountNumber;
  String? accountName;

  DefaultProperties({
    this.fleetId,
    this.fleetName,
    this.accountNumber,
    this.accountName,
  });

  factory DefaultProperties.fromJson(Map<String, dynamic> json) =>
      DefaultProperties(
        fleetId: json['fleetId'] ?? '',
        fleetName: json['fleetName'] ?? '',
        accountNumber: json['accountNumber'] ?? '',
        accountName: json['accountName'] ?? '',
      );
}
