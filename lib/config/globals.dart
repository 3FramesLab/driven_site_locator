import 'package:driven_common_sl_pkg/dynatrace/driven_dynatrace.dart';
import 'package:driven_site_locator/analytics/aep_core.dart';
import 'package:driven_site_locator/analytics/driven_analytics.dart';
import 'package:driven_site_locator/new_site_locator/models/google_places/predictions.dart';
import 'package:driven_site_locator/new_site_locator/models/google_places/structured_formatting.dart';
import 'package:driven_site_locator/new_site_locator/modules/site_ratings/models/site_place_id.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart' as url_launcher;

class Globals {
  static final Globals _singleton = Globals._internal();
  factory Globals() => _singleton;
  Globals._internal();

  late DrivenDynatrace dynatrace;
  late AEPCore analytics;
  String? _appFlavor;
  // late bool isComdata;
  // late String packageId;
  // late String androidCertSignature;
  late SharedPreferences sharedPreferences;
  late Future<bool> Function(String, {LaunchMode mode}) launch;
  late Future<bool> Function(String) canLaunch;
  final HiveInterface hive = Hive;
  String? _appLogoPath;

  Future<void> init({
    required String flavor,
  }) async {
    _appFlavor = flavor;
    initializeAnalytics();
    initializeDynatrace();
    // setAppLogoPath(appLogoPath);
    await initializeSharedPreferences();
    await initializeHiveDB();
    launch = url_launcher.launchUrlString;
    canLaunch = url_launcher.canLaunchUrlString;
  }

  void initializeAnalytics() {
    analytics = DrivenAnalytics();
  }

  void initializeDynatrace() {
    dynatrace = DrivenDynatrace.init();
  }

  Future<void> initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  String get appFlavor => _appFlavor ?? 'comdata';

  // void setAppFlavor(String? appFlavor) {
  //   _appFlavor = appFlavor;
  // }

  // void setAppLogoPath(String? appLogoPath) {
  //   _appLogoPath = appLogoPath;
  // }

  String get appLogoPath => _appLogoPath ?? '';

  static Future<void> initializeHiveDB() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(SLInternalText.predictionsTypeId)) {
      Hive.registerAdapter(PredictionsAdapter());
    }
    if (!Hive.isAdapterRegistered(SLInternalText.structuredFormattingTypeId)) {
      Hive.registerAdapter(StructuredFormattingAdapter());
    }
    if (!Hive.isAdapterRegistered(SLInternalText.sitePlaceIdTypeId)) {
      Hive.registerAdapter(SitePlaceIdAdapter());
    }
  }
}
