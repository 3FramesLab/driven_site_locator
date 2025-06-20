import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';

class AdminAccountDetailResponse
    implements Decodable<AdminAccountDetailResponse> {
  String? accountNumber;
  String? accountName;
  String? status;
  String? sysAccountId;
  String? brand;
  String? product;
  String? acctCrtDate;
  String? billPayVendor;
  String? customerUI;
  String? productType;

  AdminAccountDetailResponse({
    this.accountNumber,
    this.accountName,
    this.status,
    this.sysAccountId,
    this.brand,
    this.product,
    this.acctCrtDate,
    this.billPayVendor,
    this.customerUI,
    this.productType,
  });

  AdminAccountDetailResponse.fromJson(Map<String, dynamic> json) {
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    status = json['status'];
    sysAccountId = json['sysAccountId'];
    brand = json['brand'];
    product = json['product'];
    acctCrtDate = json['acctCrtDate'];
    billPayVendor = json['billPayVendor'];
    customerUI = json['customerUI'];
    productType = json['productType'];
  }

  @override
  AdminAccountDetailResponse decode(dynamic json) =>
      AdminAccountDetailResponse.fromJson(json);
}
