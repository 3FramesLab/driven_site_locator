import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:get/get.dart';

class BackToMapButton extends StatelessWidget {
  final void Function()? onPressed;
  const BackToMapButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      onPressed: onPressed ?? Get.back,
      child: Row(
        children: const [
          SizedBox(
            width: 17,
            child: Icon(
              Icons.arrow_back_ios,
              color: DrivenColors.purple,
            ),
          ),
          SizedBox(
            width: 42,
            child: Text(
              SiteLocatorConstants.backToMapLabel,
              style: TextStyle(
                  fontSize: FontSizes.size17,
                  color: DrivenColors.purple,
                  fontFamily: DrivenFonts.avertaFontFamily),
              textScaleFactor: 1,
            ),
          ),
        ],
      ),
    );
  }
}
