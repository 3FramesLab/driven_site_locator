import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/models/cards/fuel_card.dart';

class FuelCardsItemView extends StatelessWidget {
  final Function() onTap;
  final FuelCard fuelCard;

  const FuelCardsItemView({
    required this.fuelCard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      shape: DrivenRectangleBorder.mediumRounded,
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return _cardTile(context);
  }

  Widget _cardTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _favoriteCardIcon(),
          _cardListTile(),
        ],
      ),
    );
  }

  ListTile _cardListTile() {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
      onTap: onTap,
      leading: _cardIcon(),
      title: _cardTitleWithBalance(),
      shape: _cardShape(),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _editIcon(),
          const SizedBox(width: 8),
          _deletIcon(),
        ],
      ),
    );
  }

  Flexible _deletIcon() {
    return Flexible(
      child: GestureDetector(
        onTap: () {},
        child: Image.asset(
          SiteLocatorAssets.deleteIcon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  Flexible _editIcon() {
    return Flexible(
      child: Image.asset(
        SiteLocatorAssets.editIcon,
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _favoriteCardIcon() {
    return Visibility(
      visible: fuelCard.isFavoriteCard ?? false,
      child: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(
          Icons.favorite,
          color: DrivenColors.black90,
          size: 22,
          semanticLabel: SemanticStrings.favoriteCard,
        ),
      ),
    );
  }

  Widget _cardIcon() {
    return const CircleAvatar(
      backgroundImage: AssetImage(SiteLocatorAssets.accountIcon),
      backgroundColor: Colors.transparent,
    );
  }

  RoundedRectangleBorder _cardShape() {
    return RoundedRectangleBorder(
      side: const BorderSide(color: DrivenColors.transparent),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _cardTitleWithBalance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fuelCard.cardNickName ?? '',
          style: f14BoldBlackDark,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
