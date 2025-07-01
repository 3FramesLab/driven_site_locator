part of map_view_module;

class SLHelpFilterItem extends StatelessWidget {
  final String title;
  final int index;
  final bool isLastIndex;
  final bool isSelected;
  final int? count;

  const SLHelpFilterItem({
    required this.title,
    required this.index,
    required this.isLastIndex,
    required this.isSelected,
    this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: index == 0 ? 10 : 0,
        right: isLastIndex ? 10 : 0,
      ),
      margin: const EdgeInsets.only(left: 12),
      child: ChoiceChip(
        padding: const EdgeInsets.all(12),
        label: Text(
          title,
          style: isSelected
              ? f14SemiboldWhite
              : f14SemiBoldBlack.copyWith(
                  color: DrivenColors.primary,
                ),
          textScaler: const TextScaler.linear(1),
        ),
        selectedColor: DrivenColors.primary,
        backgroundColor: DrivenColors.white,
        shadowColor: DrivenColors.grey.withOpacity(0.5),
        selected: isSelected,
        elevation: 2,
        onSelected: (_) {},
      ),
    );
  }
}
