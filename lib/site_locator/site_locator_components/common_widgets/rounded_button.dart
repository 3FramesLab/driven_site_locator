import 'package:driven_site_locator/driven_components/driven_components.dart';

class RoundedButton2 extends StatelessWidget {
  final double height;
  final VoidCallback? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? disabledBackgroundColor;
  final BorderSide? side;
  final TextStyle? buttonTextStyle;

  const RoundedButton2({
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    this.foregroundColor = DrivenColors.white,
    this.height = 48.0,
    this.disabledBackgroundColor = DrivenColors.disabledButtonColor,
    this.side,
    this.buttonTextStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: _style(),
      child: child,
    );
  }

  ButtonStyle _style() {
    return RoundedButtonStyle(
      backgroundColor: backgroundColor,
      primary: foregroundColor,
      minimumHeight: height,
      disabledBackgroundColor: disabledBackgroundColor!,
      side: side,
    );
  }
}
