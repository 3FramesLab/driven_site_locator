part of sl_filter_module;

class SLFilterOptionContent extends StatelessWidget {
  final Filter filter;

  const SLFilterOptionContent({
    required this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecor,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PanelHandle(),
              _titleRow,
              _listView,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _listView => SLFilterOptionList(filter: filter);

  Widget get _titleRow => Row(
        children: [
          Expanded(child: _titleText),
          GallonUpFilterSwitchRow(filter: filter),
        ],
      );

  Widget get _titleText => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 16, left: 16),
        child: DrivenText(
          text: filter.subFilterHeader,
          style: f22BoldBlackDark,
        ),
      );

  BoxDecoration get boxDecor => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        color: Colors.white,
      );

  Widget get _actionButtons => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(child: SLApplyFilterButton(filter: filter)),
            if (!filter.radioButton) ...[
              const SizedBox(width: 16),
              Expanded(child: SLClearFilterButton(filter: filter))
            ]
          ],
        ),
      );
}
