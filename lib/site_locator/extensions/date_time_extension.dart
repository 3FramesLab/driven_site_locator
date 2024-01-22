import 'dart:io';

/// This extension can help to mock the current timestamp in test cases.
/// set [customTime] before executing the test case.
extension DateTimeExtension on DateTime {
  static DateTime? _customTime;

  static DateTime get now {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return _customTime ?? DateTime.now();
    }
    return DateTime.now();
  }

  static set customTime(DateTime customTime) {
    _customTime = customTime;
  }
}
