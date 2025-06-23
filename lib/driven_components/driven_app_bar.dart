import 'package:driven_common_sl_pkg/common/driven_constants.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';

class DrivenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool centerTitle;
  final Widget? title;
  final PreferredSizeWidget? preferredSizeWidget;
  final Widget? leading;
  final Widget? flexibleSpace;
  final double? toolBarHeight;
  final EdgeInsetsGeometry padding;
  final double titleSpacing;
  final double elevation;
  final bool showBackButton;
  final String backButtonText;
  final double buttonTextWidth;
  final Function()? onBackPressed;

  @override
  final Size preferredSize;

  DrivenAppBar({
    Key? key,
    this.actions,
    this.backgroundColor = DrivenColors.pageBackgroundColor,
    this.centerTitle = true,
    this.title,
    this.preferredSizeWidget,
    this.onBackPressed,
    this.leading,
    this.flexibleSpace,
    this.toolBarHeight,
    this.backButtonText = DrivenConstants.back,
    this.showBackButton = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.titleSpacing = 10,
    this.buttonTextWidth = 42,
    this.elevation = 0,
  })  : preferredSize = Size.fromHeight(toolBarHeight ?? kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: AppBar(
        actions: actions,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        centerTitle: centerTitle,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            color: elevation > 0
                ? DrivenColors.black.withOpacity(0.12)
                : Colors.transparent,
            width: elevation > 0 ? elevation : 0,
          ),
        ),
        leading: showBackButton ? _backButton : leading,
        leadingWidth: 80,
        title: title,
        flexibleSpace: flexibleSpace,
        toolbarHeight: toolBarHeight,
        titleSpacing: titleSpacing,
        bottom: preferredSizeWidget,
      ),
    );
  }

  Widget get _backButton => DrivenBackButton(
        iconWidth: 24,
        buttonText: backButtonText,
        buttonTextWidth: buttonTextWidth,
        onPressed: onBackPressed,
      );
}
