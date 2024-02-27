import 'package:flutter/material.dart';

class WebHamburgerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 25),
      height: 24,
      child: GestureDetector(
        onTap: () {},
        child: Image.asset(
          'assets/images/hamburger_menu.png',
        ),
      ),
    );
  }
}
