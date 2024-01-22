import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/z_site_info_section_heading.dart';
import 'package:flutter/material.dart';

class ServicesCommonSection extends StatelessWidget {
  const ServicesCommonSection(this.headingLabel, this.serviceList);

  final List<Widget> serviceList;
  final String headingLabel;
  @override
  Widget build(BuildContext context) {
    return serviceList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SiteInfoSectionHeading(headingLabel),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: serviceList,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
