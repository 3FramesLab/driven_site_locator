import 'package:driven_site_locator/driven_components/back_disabled_wrapper.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_components/inactivity/inactivity_module.dart';
import 'package:driven_site_locator/driven_components/sliding_up_panel/sliding_up_panel_module.dart';

class DrivenScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final bool disableBack;
  final Color? backgroundColor;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final bool goesInactive;
  final bool isSlideUpPanelRequired;
  final bool resizeToAvoidBottomInset;
  final bool isChatBubbleRequired;

  const DrivenScaffold({
    Key? key,
    this.appBar,
    this.disableBack = false,
    this.backgroundColor = DrivenColors.pageBackgroundColor,
    this.body,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.goesInactive = true,
    this.isSlideUpPanelRequired = true,
    this.isChatBubbleRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    widget = _drivenSlideUpPanel(widget);
    // widget = _forceUpdateWrapper(widget);
    widget = _inactivityWrapper(widget);
    widget = _textScaleClampWrapper(widget);
    return _backDisabledWrapper(widget);
  }

  Widget _drivenSlideUpPanel(Widget widget) {
    if (isSlideUpPanelRequired) {
      return DrivenSlideUpPanel(body: widget);
    } else {
      return widget;
    }
  }

  Widget _backDisabledWrapper(Widget widget) {
    if (disableBack) {
      return BackDisabledWrapper(child: widget);
    } else {
      return widget;
    }
  }

  Widget _inactivityWrapper(Widget widget) {
    return goesInactive ? InactivityWrapper(child: widget) : widget;
  }

  // Widget _forceUpdateWrapper(Widget widget) {
  //   return ForceUpdateWrapper(child: widget);
  // }

  Widget _textScaleClampWrapper(Widget widget) {
    return TextScaleClamp(child: widget);
  }
}
