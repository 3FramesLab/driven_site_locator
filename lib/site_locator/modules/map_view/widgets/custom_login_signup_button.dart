import 'package:driven_site_locator/driven_components/driven_components.dart';

class CustomLoginSignupButton extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  final DrivenTextStyle primaryTextStyle;
  final DrivenTextStyle secondaryTextStyle;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const CustomLoginSignupButton({
    required this.primaryText,
    required this.secondaryText,
    required this.onPressed,
    this.primaryTextStyle = f16SemiboldBlack,
    this.secondaryTextStyle = f14RegularBlack,
    this.backgroundColor = DrivenColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                primaryText,
                style: primaryTextStyle,
              ),
              const SizedBox(height: 4),
              Text(
                secondaryText,
                style: secondaryTextStyle,
              )
            ],
          ),
        ),
        Icon(
          Icons.keyboard_arrow_right_rounded,
          color: primaryTextStyle.color!,
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: primaryTextStyle.color!.withAlpha(110)),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
