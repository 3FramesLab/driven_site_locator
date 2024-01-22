import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';

class CancelText extends StatelessWidget {
  final VoidCallback onCancelTap;
  const CancelText({required this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: SemanticStrings.noLocationsModalCancelButton,
      child: GestureDetector(
        onTap: onCancelTap,
        child: _cancelText(),
      ),
    );
  }

  Text _cancelText() {
    return const Text(
      SiteLocatorConstants.locationEnableDialogSecondaryText,
      style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.black,
          fontSize: 16,
          fontFamily: DrivenFonts.avertaFontFamily,
          fontWeight: DrivenFonts.fontWeightSemibold),
    );
  }
}
