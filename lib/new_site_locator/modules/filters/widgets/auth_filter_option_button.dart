part of sl_filter_module;

class AuthFilterOptionRadioButton extends StatelessWidget {
  const AuthFilterOptionRadioButton({
    required this.color,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Color color;
  final Text text;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 36,
      decoration: buttonDecor(color),
      child: TextButton(
        onPressed: onPressed.call,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            text,
            if (isSelected) selectedTick,
          ],
        ),
      ),
    );
  }

  Widget get selectedTick => const Padding(
        padding: EdgeInsets.only(left: 6),
        child: Icon(Icons.check, color: DrivenColors.white, size: 16),
      );

  BoxDecoration buttonDecor(Color buttonColor) {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(6),
        topLeft: Radius.circular(6),
        bottomRight: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      ),
      color: buttonColor,
    );
  }
}
