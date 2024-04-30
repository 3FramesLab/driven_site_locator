import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/fuel_card_nick_name_field.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/fuel_card_number_field.dart';

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
