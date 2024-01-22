import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';

class MapPinWithDescription extends StatelessWidget {
  final String mapPinImage;
  final String mapPinDescription;
  const MapPinWithDescription({
    required this.mapPinImage,
    required this.mapPinDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(mapPinImage),
          height: SetUpWizardConstants.discountPinDemoHeight,
        ),
        const SizedBox(height: 8),
        Text(
          mapPinDescription,
          textAlign: TextAlign.center,
          style: f14SemiboldBlack,
        )
      ],
    );
  }
}
