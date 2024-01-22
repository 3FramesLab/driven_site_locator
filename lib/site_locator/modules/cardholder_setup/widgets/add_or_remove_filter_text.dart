part of cardholder_setup_module;

class AddOrRemoveFilterText extends StatelessWidget {
  const AddOrRemoveFilterText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 24),
        child: Text(
          CardholderSetupConstants.youCanAddRemoveFilters,
          style: f14RegularBlack,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
