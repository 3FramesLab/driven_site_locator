import 'package:driven/constants/view_text.dart';
import 'package:driven/data/data_sources/remote/dynatrace_logs_tracking.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:flutter/material.dart';

class KillDupFuelPriceCalls {
  static List<String> siteIdsRequestedList = [];
  static int cleanThreshold = 20000;
  static String? currentFleetId;
  static String freeAgentId = r'$$SYS';

  static void setCurrentFleetId(String customerIdKey) {
    currentFleetId = lowercaseFleetId(customerIdKey);
  }

  static String lowercaseFleetId(String customerIdKey) {
    return customerIdKey.isNotEmpty ? customerIdKey.toLowerCase() : freeAgentId;
  }

  static void trackSiteIds(List<String?> siteIds,
      {bool isUserLoggedIn = false}) {
    clean();
    final formattedSiteIds =
        formatSetOfSiteIds(siteIds, isUserLoggedIn: isUserLoggedIn);
    siteIdsRequestedList.add(formattedSiteIds);
  }

  static bool lookupSiteIds(List<String?> siteIds,
      {bool isUserLoggedIn = false}) {
    final formattedSiteIds =
        formatSetOfSiteIds(siteIds, isUserLoggedIn: isUserLoggedIn);
    final exists = siteIdsRequestedList.contains(formattedSiteIds);
    return exists;
  }

  static void remove(List<String?> siteIds, {bool isUserLoggedIn = false}) {
    final formattedSiteIds =
        formatSetOfSiteIds(siteIds, isUserLoggedIn: isUserLoggedIn);
    final info = siteIds.join(',');
    try {
      siteIdsRequestedList.remove(formattedSiteIds);
      fireDynatraceFuelPriceAPILogs(
          'API failed and sites removed from kill-track: [$info]');
    } catch (_) {
      fireDynatraceFuelPriceAPILogs(
          'Catch block while remove from kill-track for sites: [$info]');
    }
  }

  static void removeByFleetId(String fleetId, {bool isUserLoggedIn = false}) {
    siteIdsRequestedList
        .removeWhere((element) => element.contains(lowercaseFleetId(fleetId)));
    debugPrint(siteIdsRequestedList.toString());
  }

  static void emptyTheSiteIds() {
    siteIdsRequestedList = [];
    currentFleetId = null;
  }

  static void clean() {
    if (siteIdsRequestedList.length > cleanThreshold) {
      siteIdsRequestedList = [];
    }
  }

  static String format(String siteIdsJoinedStr, {bool isUserLoggedIn = false}) {
    return '${prefix(isUserLoggedIn: isUserLoggedIn)}-$siteIdsJoinedStr';
  }

  static String formatSetOfSiteIds(List<String?> siteIds,
      {bool isUserLoggedIn = false}) {
    final formatted = format(siteIds.join(','), isUserLoggedIn: isUserLoggedIn);
    final fleetIdStr = lowercaseFleetId(currentFleetId ?? freeAgentId);
    return '$fleetIdStr-$formatted';
  }

  static String prefix({bool isUserLoggedIn = false}) {
    return isUserLoggedIn ? SLViewText.activeCardStatus : 'U';
  }
}
