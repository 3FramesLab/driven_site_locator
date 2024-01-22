import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';

class FavoriteCardMold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const padding = SetUpWizardConstants.containerPadding;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Container(
        width: 185,
        padding: padding,
        child: Wrap(
          children: [
            const Icon(Icons.favorite_border_outlined),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                SiteLocatorConstants.addToFavorites,
                style: f16BoldBlackDark.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
