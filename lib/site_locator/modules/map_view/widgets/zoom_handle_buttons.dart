import 'package:driven_common/common/driven_dimensions.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';

class ZoomHandleButtons extends StatelessWidget {
  final Function()? onZoomInIconTap;
  final Function()? onZoomOutIconTap;

  const ZoomHandleButtons({
    Key? key,
    this.onZoomInIconTap,
    this.onZoomOutIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onZoomInIconTap,
          child: _buildCard(SiteLocatorAssets.zoomInIcon),
        ),
        const SizedBox(height: DrivenDimensions.dp8),
        GestureDetector(
          onTap: onZoomOutIconTap,
          child: _buildCard(SiteLocatorAssets.zoomOutIcon),
        ),
      ],
    );
  }

  Card _buildCard(String image) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(6),
        height: 36,
        width: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
