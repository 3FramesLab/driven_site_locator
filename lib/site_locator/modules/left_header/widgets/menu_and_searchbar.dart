import 'package:driven_site_locator/site_locator/modules/left_header/widgets/hamberger_menu.dart';
import 'package:driven_site_locator/site_locator/modules/search_locations/search_location_module.dart';
import 'package:flutter/material.dart';

class MenuAndSearchbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HambergerMenu(),  
        const SizedBox(width: 275, child: SearchPlaceTextField()),
      ],
    );
  }
}
