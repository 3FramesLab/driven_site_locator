import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:get/get.dart';

class FuelCardsDisplayText extends StatelessWidget {
  final TextStyle style;
  final double? nickNameWidth;

  FuelCardsDisplayText({
    this.style = f14SemiboldBlack,
    this.nickNameWidth,
  });

  final FuelCardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.hasNoCards()
          ? _headerText(ViewText.addCardToSeeDiscounts)
          : _nickNameWithNumber,
    );
  }

  // Show favourite card as header text
  Widget get _nickNameWithNumber {
    return Row(
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: nickNameWidth ?? Get.width * 0.4),
          child: _headerText(controller.favoriteFuelCard.cardNickName ?? ''),
        ),
        const SizedBox(width: 3),
        _headerText(
          '- *${controller.favoriteFuelCard.cardLastFourDigit ?? ''}',
        ),
      ],
    );
  }

  Widget _headerText(String text) {
    return Body1SemiBold16Lh23(
      text,
      style: f16SemiboldBlackDark,
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}
