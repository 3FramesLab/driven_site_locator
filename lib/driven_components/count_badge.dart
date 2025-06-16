import 'package:driven_site_locator/driven_components/driven_components.dart';

class CountBadge extends StatelessWidget {
  final int count;
  final bool isWhite;

  const CountBadge({
    required this.count,
    this.isWhite = false,
    Key? key,
  }) : super(key: key);

  const CountBadge.white({
    required this.count,
    this.isWhite = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      alignment: Alignment.center,
      decoration: boxDecoration,
      child: countText,
    );
  }

  Widget get countText => Text(
        count > 9 ? '9+' : '$count',
        style: isWhite
            ? f12BoldWhite.copyWith(color: DrivenColors.primary)
            : f12BoldWhite,
      );

  Decoration get boxDecoration => BoxDecoration(
        color: isWhite ? DrivenColors.white : DrivenColors.primary,
        shape: BoxShape.circle,
      );
}
