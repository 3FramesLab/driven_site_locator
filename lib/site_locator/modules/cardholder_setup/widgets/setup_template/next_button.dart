part of cardholder_setup_module;

class NextButton extends StatelessWidget {
  final Function()? onNextPressed;

  const NextButton({
    this.onNextPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        if (onNextPressed != null) {
          onNextPressed?.call();
        }
      },
      text: ViewText.nextButton,
    );
  }
}
