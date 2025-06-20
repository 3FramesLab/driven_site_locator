part of extensions_module;

extension DateTimeExtension on DateTime {
  static DateTime? _customTime;
  static Map<String, String>? _environment;

  static DateTime get now {
    if (_environment != null && _environment!.containsKey('FLUTTER_TEST')) {
      return _customTime ?? DateTime.now();
    }
    return DateTime.now();
  }

  static set customTime(DateTime? customTime) {
    _customTime = customTime;
  }

  static set environment(Map<String, String> environment) {
    _environment = environment;
  }

  static void reset() {
    _customTime = null;
    _environment = null;
  }
}
