part of sl_filter_module;

class BrandQuickFilterItem extends StatelessWidget {
  final VoidCallback onChanged;
  final bool value;
  final SiteFilter siteFilter;

  const BrandQuickFilterItem({
    required this.siteFilter,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: _checkbox(),
    );
  }

  Widget _checkbox() {
    return DrivenCheckbox(
      onChanged: (_) => onChanged(),
      value: value,
      textWidget: Text(
        siteFilter.label,
        style: f16RegularBlack,
        overflow: TextOverflow.visible,
      ),
      onTap: onChanged,
    );
  }
}
