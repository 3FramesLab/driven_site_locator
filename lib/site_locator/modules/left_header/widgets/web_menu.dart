import 'package:flutter/material.dart';

class WebHamburgerMenu extends StatelessWidget {
  final Function()? onMenuIconTap;

  const WebHamburgerMenu({
    Key? key,
    this.onMenuIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 25),
      height: 24,
      child: GestureDetector(
        onTap: onMenuIconTap,
        child: Image.asset(
          'assets/images/hamburger_menu.png',
        ),
      ),
    );
  }
}
