import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';

class WebMenuRow extends StatelessWidget {
  final String title;
  final void Function() onRowTap;
  final Icon? icon;
  final AssetImage? imageIcon;
  final bool isExpandable;
  final Widget? expandableChildWidget;

  const WebMenuRow({
    required this.title,
    required this.onRowTap,
    this.icon,
    this.imageIcon,
    this.isExpandable = false,
    this.expandableChildWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onRowTap,
      leading: _icon(),
      title: Text(
        title,
        style: _textStyle,
      ),
    );
  }

  TextStyle get _textStyle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  Widget? _icon() => imageIcon != null
      ? Image(
          image: imageIcon!,
          height: SiteLocatorDimensions.dp28,
          width: SiteLocatorDimensions.dp28,
        )
      : icon;
}
