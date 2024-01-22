import 'package:driven_site_locator/driven_components/driven_components.dart';

class SiteLocatorMapViewBackButton extends StatelessWidget {
  final void Function()? onBackButtonPressed;
  const SiteLocatorMapViewBackButton({this.onBackButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(45)),
      ),
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DrivenBackButton(onPressed: onBackButtonPressed),
      ),
    );
  }
}
