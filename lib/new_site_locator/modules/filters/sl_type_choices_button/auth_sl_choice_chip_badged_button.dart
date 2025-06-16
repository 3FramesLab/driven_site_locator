part of sl_filter_module;

class AuthSLChoiceChipBadgedButton extends StatelessWidget {
  const AuthSLChoiceChipBadgedButton({
    required this.item,
    required this.isSelectedOption,
    this.count,
  });

  final Filter item;
  final bool isSelectedOption;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return count != null && count != 0
        ? Container(
            margin: const EdgeInsets.only(top: 3),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AuthSLChoiceChipButton(
                  item: item,
                  isSelectedOption: isSelectedOption,
                ),
                _countBadge(count!),
              ],
            ))
        : AuthSLChoiceChipButton(
            item: item,
            isSelectedOption: isSelectedOption,
          );
  }

  Widget _countBadge(int count) {
    return Positioned(
      right: -1,
      top: -1,
      child: CountBadge.white(count: count),
    );
  }
}
