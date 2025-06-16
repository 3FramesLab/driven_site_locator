import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:flutter/material.dart';

class SiteLocatorTextFieldStyle {
  static final SiteLocatorTextFieldStyle _singleton =
      SiteLocatorTextFieldStyle._internal();

  factory SiteLocatorTextFieldStyle() => _singleton;

  SiteLocatorTextFieldStyle._internal();

  BoxDecoration _searchTextfieldIconDecoration(Color? color) => BoxDecoration(
        border: Border.all(
          color: SLColors.blackWithOpacity75,
          width: 25,
        ),
        color: color,
        shape: BoxShape.circle,
      );

  Widget searchTextFieldIconContainer({Widget? child, Color? color}) =>
      Container(
        margin: const EdgeInsets.all(4),
        decoration: _searchTextfieldIconDecoration(color),
        child: child,
      );

  InputDecoration searchTextFieldDecoration({
    Widget? suffixIcon,
    String? hintText,
    double borderWidth = 1.0,
  }) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: _searchTextFieldBorder(width: borderWidth),
      focusedBorder: _searchTextFieldBorder(width: borderWidth),
      fillColor: Colors.white,
      filled: true,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
    );
  }

  OutlineInputBorder _searchTextFieldBorder({required double width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.black87,
        width: width,
      ),
    );
  }
}
