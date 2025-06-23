part of sl_widget_module;

class SiteLocatorDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;

  const SiteLocatorDivider({
    this.height = 0,
    this.thickness = 1,
    this.color = SLColors.lightGreyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      height: height,
    );
  }
}
