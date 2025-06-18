import 'dart:async' show Future;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  PreferenceUtils._();

  static Future<SharedPreferences> get _instance async =>
      _sharedPreferences ??= await SharedPreferences.getInstance();
  static SharedPreferences? _sharedPreferences;

  static Future<SharedPreferences?> init() async {
    return _instance;
  }

  static String? getString(String key, {String? defaultValue}) {
    final String? value = _sharedPreferences?.getString(key);
    if (value != null) {
      return base64Decode(value);
    }
    return defaultValue;
  }

  static Future<bool> setString(String key, String value) async {
    final preference = await _instance;
    return preference.setString(key, base64Encode(value));
  }

  static bool? getBool(String key, {bool? defaultValue}) {
    return _sharedPreferences?.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, {required bool value}) async {
    final preference = await _instance;
    return preference.setBool(key, value);
  }

  static Future<bool> setInt(String key, {int? value}) async {
    final preference = await _instance;
    final String encodedValue =
        base64Url.encode(utf8.encode((value ?? '').toString()));
    return preference.setString(key, encodedValue);
  }

  static int? getInt(String key, {int? defaultValue}) {
    final String? value = _sharedPreferences?.getString(key);
    try {
      if (value != null) {
        return int.parse(utf8.decode(base64.decode(value)));
      }
    } catch (_) {}
    return defaultValue;
  }

  static Future<bool> deleteByKey(String key) async {
    final preference = await _instance;
    bool result = false;
    if (preference.containsKey(key)) {
      result = await preference.remove(key);
    }
    return result;
  }

  static Future<void> clear() async {
    await _sharedPreferences?.clear();
  }

  static List<String>? getStringList(String key, {List<String>? defaultValue}) {
    final List<String> decodedItems = [];
    final List<String>? storedStringList =
        _sharedPreferences?.getStringList(key);
    if (storedStringList != null) {
      for (final element in storedStringList) {
        decodedItems.add(utf8.decode(base64.decode(element)));
      }
      return decodedItems;
    }
    return defaultValue;
  }

  static Future<bool> setStringList(String key,
      {required List<String> value}) async {
    final List<String> encodedList = [];
    final preference = await _instance;
    for (final element in value) {
      encodedList.add(base64Url.encode(utf8.encode(element)));
    }
    return preference.setStringList(key, encodedList);
  }

  static String base64Encode(String plainText) =>
      base64.encode(utf8.encode(plainText));

  static String base64Decode(String encodedText) =>
      utf8.decode(base64.decode(encodedText));
}
