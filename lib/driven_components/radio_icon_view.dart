import 'package:driven_site_locator/driven_components/driven_components.dart';

class RadioIconView extends StatelessWidget {
  final bool isSelected;

  const RadioIconView({
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: _decoration,
      child: _child,
    );
  }

  BoxDecoration get _decoration => isSelected
      ? _outerCircleSelectedDecoration
      : _outerCircleDeselectedDecoration;

  BoxDecoration get _outerCircleSelectedDecoration => const BoxDecoration(
        shape: BoxShape.circle,
        color: DrivenColors.primary,
      );

  BoxDecoration get _outerCircleDeselectedDecoration => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: DrivenColors.grey700,
          width: 2,
        ),
      );

  Widget get _child => isSelected ? _innerCircle : const SizedBox.shrink();

  Widget get _innerCircle => Center(
        child: Container(
          height: 12,
          width: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: DrivenColors.white,
          ),
        ),
      );
}
