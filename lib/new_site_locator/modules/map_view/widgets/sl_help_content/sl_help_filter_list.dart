part of map_view_module;

class SLHelpFilterList extends StatelessWidget {
  final List<String> filterHeaders;

  const SLHelpFilterList({
    required this.filterHeaders,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterHeaders.length,
        itemBuilder: _itemBuilder,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final isSelected = filterHeaders[index] == SLInternalText.merchants ||
        filterHeaders[index] == SLInternalText.fuel;
    final isLastIndex = index == filterHeaders.length - 1;

    return isSelected
        ? Container(
            margin: const EdgeInsets.only(top: 3),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SLHelpFilterItem(
                  title: filterHeaders[index],
                  index: index,
                  isLastIndex: isLastIndex,
                  isSelected: isSelected,
                ),
                _countBadge(1),
              ],
            ))
        : SLHelpFilterItem(
            title: filterHeaders[index],
            index: index,
            isLastIndex: isLastIndex,
            isSelected: isSelected,
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
