import 'package:driven_common/styles/styles_module.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:flutter/material.dart';

class SiteLocatorMenuRow extends StatelessWidget {
  final String title;
  final AssetImage? imageIcon;
  final void Function()? buttonAction;
  final Icon? icon;
  final Color backgroundColor;
  final String? subTitle;
  final TextStyle subTitleStyle;

  const SiteLocatorMenuRow({
    required this.title,
    this.imageIcon,
    this.buttonAction,
    this.icon,
    this.backgroundColor = DrivenColors.brandPurple,
    this.subTitle,
    this.subTitleStyle = const TextStyle(fontSize: SiteLocatorDimensions.dp16),
  });

  @override
  Widget build(BuildContext context) {
    return _bodyContainer(
      onTap: buttonAction,
      title: _buildTitle(context),
      subtitle: _buildSubTitle(),
      leading: _leading(),
    );
  }

  Widget _bodyContainer({
    void Function()? onTap,
    Widget? title,
    Widget? subtitle,
    Widget? leading,
  }) {
    return Container(
      height: SiteLocatorDimensions.dp70,
      child: ListTile(
        visualDensity:
            const VisualDensity(horizontal: SiteLocatorDimensions.dpNegative4),
        contentPadding: const EdgeInsets.symmetric(
          vertical: SiteLocatorDimensions.dp1,
          horizontal: SiteLocatorDimensions.dp15,
        ),
        onTap: onTap,
        dense: true,
        title: title,
        subtitle: subtitle,
        leading: leading,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    Widget titleWidget = Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );

    if (subTitle == null) {
      titleWidget = Align(
        alignment: Alignment.centerLeft,
        child: titleWidget,
      );
    }

    return titleWidget;
  }

  Widget? _buildSubTitle() {
    if (subTitle != null) {
      return Text(
        subTitle!,
        style: subTitleStyle,
      );
    }
    return null;
  }

  dynamic _leading() => CircleAvatar(
        backgroundColor: backgroundColor,
        child: _icon(),
      );

  Widget? _icon() => imageIcon != null
      ? Image(
          image: imageIcon!,
          height: SiteLocatorDimensions.dp28,
          width: SiteLocatorDimensions.dp28,
        )
      : icon;
}
