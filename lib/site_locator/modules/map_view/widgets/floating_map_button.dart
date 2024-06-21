part of map_view_module;

class FloatingMapButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onPressed;
  final bool canShowBorder;
  final MaterialStateProperty<EdgeInsetsGeometry>? buttonPadding;

  const FloatingMapButton({
    required this.label,
    required this.icon,
    this.onPressed,
    this.canShowBorder = true,
    this.buttonPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle(),
      child: iconLabelWrap(),
    );
  }

  Widget iconLabelWrap() {
    return Wrap(
      children: [
        Icon(icon, size: 25, color: Colors.black),
        const SizedBox(width: 5),
        buttonLabel(),
      ],
    );
  }

  Widget buttonLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        label,
        style: f16SemiboldBlackDark,
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      padding: buttonPadding ??
          MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: canShowBorder
          ? MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(),
              ),
            )
          : null,
    );
  }
}
