import 'package:driven_common/driven_common_resources_module.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:flutter/material.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 158,
      child: OutlinedButton(
        onPressed: () {
          // TODO
        },
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          foregroundColor: Colors.black,
          side: const BorderSide(width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_outlined),
            SizedBox(width: 2),
            Text(
              SiteLocatorConstants.filters,
              style: f14SemiboldBlack,
            ),
          ],
        ),
      ),
    );
  }
}
