part of map_view_module;

class AddFuelCardForm extends StatelessWidget {
  AddFuelCardForm({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LabelText(ViewText.cardNumber),
            const SizedBox(height: 5),
            FuelCardNumberField(),
            const SizedBox(height: 25),
            const LabelText(ViewText.cardNickname),
            const SizedBox(height: 5),
            FuelCardNickNameField(),
          ],
        ));
  }
}
