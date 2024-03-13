part of filter_module;

class EnhancedFilterCheckbox extends StatelessWidget {
  final SiteFilter filter;
  final bool fromSetUpWizard;
  final EnhancedFilterController filterController = Get.find();

  EnhancedFilterCheckbox({
    required this.filter,
    this.fromSetUpWizard = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Widget _buildContainer() {
    return kIsWeb
        ? Container(
            width: 375,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: _buildDrivenCheckbox(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: _buildDrivenCheckbox(),
          );
  }

  DrivenCheckbox _buildDrivenCheckbox() {
    return DrivenCheckbox(
      textWidget: Text(
        filter.label,
        style: f14RegularBlack,
      ),
      value: filter.isChecked,
      onChanged: (value) => onCheckboxChanged(isChecked: value),
      onTap: onCheckboxTitleClick,
    );
  }

  void onCheckboxChanged({bool? isChecked}) {
    if (isChecked != null) {
      trackAnalytics(isChecked: isChecked);
      filterController.onFilterCheckChange(
        siteFilter: filter,
        isChecked: isChecked,
      );
    }
  }

  void onCheckboxTitleClick() => filterController.onFilterCheckChange(
        siteFilter: filter,
        isChecked: !filter.isChecked,
      );

  void trackAnalytics({bool? isChecked}) {
    if (isChecked!) {
      trackAction(
        _getTrackActionName,
        // // adobeCustomTag: AdobeTagProperties.enhancedFilters,
      );
    }
  }

  String get _getTrackActionName =>
      'enhanced filters screen : ${filter.label.toLowerCase()} filter enabled/applied click';
}
