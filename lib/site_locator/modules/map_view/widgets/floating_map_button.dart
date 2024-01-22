part of map_view_module;

class FloatingMapButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onPressed;
  const FloatingMapButton({
    required this.label,
    required this.icon,
    this.onPressed,
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
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(),
        ),
      ),
    );
  }
}
