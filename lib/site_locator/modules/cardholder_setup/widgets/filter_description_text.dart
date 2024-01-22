part of cardholder_setup_module;

class FilterDescriptionText extends StatelessWidget {
  const FilterDescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        CardholderSetupConstants.addFilterDescription,
        style: f16SemiboldBlackDark,
        textAlign: TextAlign.start,
      ),
    );
  }
}
