part of map_view_module;

class FloatingMapButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onPressed;
  final String? semanticsLabel;
  const FloatingMapButton({
    required this.label,
    required this.icon,
    this.onPressed,
    this.semanticsLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle(),
        child: iconLabelWrap(),
      ),
    );
  }

  Widget iconLabelWrap() {
    return Row(
      children: [
        Icon(icon, size: 25, color: Colors.black),
        const SizedBox(width: 5),
        buttonLabel(),
      ],
    );
  }

  Widget buttonLabel() {
    return Expanded(
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            )));
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(),
        ),
      ),
    );
  }
}
