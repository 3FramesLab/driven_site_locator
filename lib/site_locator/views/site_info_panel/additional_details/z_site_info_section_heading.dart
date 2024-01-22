import 'package:driven_site_locator/driven_components/driven_components.dart';

class SiteInfoSectionHeading extends StatelessWidget {
  const SiteInfoSectionHeading(
    this.heading, {
    this.iconData = Icons.store_mall_directory_outlined,
  });

  final String heading;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          Icon(iconData, size: 20),
          const HorizontalSpacer(size: 10),
          Text(heading, style: f14ExtraBoldBlackDark),
        ],
      ),
    );
  }
}
