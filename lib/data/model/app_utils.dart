import 'dart:convert';

import 'package:driven_common/extensions/extensions_module.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppUtils {
  static String get appVersionName =>
      DrivenSiteLocator.instance.appVersionNumber;

  static bool get isComdata =>
      DrivenSiteLocator.instance.flavor == AppFlavor.comdata;

  static bool get isFuelman =>
      DrivenSiteLocator.instance.flavor == AppFlavor.fuelman;

  // TODO(Smeet): important set from super-app
  static bool isQABuild = false;

  static bool get isQADebugMode => isQABuild && kDebugMode;

  static bool get noAppFlavor =>
      DrivenSiteLocator.instance.flavor == AppFlavor.none;

  static bool get isFuelmanWeb =>
      DrivenSiteLocator.instance.flavor == AppFlavor.fuelmanWeb;

  static String get flavor => DrivenSiteLocator.instance.flavor.name;

  static bool get isIos => defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static Future<dynamic> readJsonFile(String path) async {
    final response = await rootBundle.loadString(path);
    return await json.decode(response);
  }

  static String? replaceNullString(String? data) =>
      data?.trim().toLowerCase() == 'null' ? null : data;

  static double getPrice(double price) => price.truncateToDecimalPlaces(2);

  static String getPriceString(double price) =>
      price.truncateDecimalsToString(2);

  // TODO(Smeet): important set from super-app
  static String versionNumber = '';
  static String buildNumber = '';
  static String driven = '';
}

enum AppFlavor {
  comdata('comdata'),
  fuelman('fuelman'),
  ifleet('ifleet'),
  fuelmanWeb('fuleman_web'),
  none('none');

  final String app;
  const AppFlavor(this.app);
}
