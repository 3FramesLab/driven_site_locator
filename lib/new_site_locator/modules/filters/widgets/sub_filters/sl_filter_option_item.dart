part of sl_filter_module;

class SLFilterOptionItem extends StatelessWidget {
  final NewSiteFilter siteFilter;
  final int index;
  final bool isRadioButton;

  final _controller = Get.find<AuthSLTypeChoicesController>();

  SLFilterOptionItem({
    required this.siteFilter,
    required this.index,
    required this.isRadioButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_viewMoreWidget) {
      return SLFilterOptionItemMore(
        siteFilter: siteFilter,
        index: index,
        isRadioButton: isRadioButton,
      );
    } else {
      return _filterRow;
    }
  }

  Widget get _filterRow => InkWell(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: DrivenColors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _icon,
              const SizedBox(width: 15),
              Expanded(child: _reasonText),
              const SizedBox(width: 12),
              _selectionButton,
            ],
          ),
        ),
      );

  Widget get _icon {
    if (siteFilter.icon.endsWith('.svg')) {
      return _svgIcon;
    } else if (siteFilter.icon.endsWith('.png')) {
      return _pngIcon;
    } else {
      return _materialIcon;
    }
  }

  Widget get _materialIcon {
    final int? codePoint = int.tryParse(siteFilter.icon);
    if (codePoint != null) {
      final iconData = getIconFromCode(codePoint);
      if (iconData != null) {
        return Icon(iconData, color: DrivenColors.primary);
      }
    }
    return const SizedBox.shrink();
  }

  Widget get _svgIcon => SvgPicture.asset(
        '${SLAssets.svgAssetsPath}/${siteFilter.icon}',
      );

  Widget get _pngIcon => Image.asset(
        '${SLAssets.slBrandLogoPath}/${siteFilter.icon}',
        height: 24,
        width: 24,
      );

  Widget get _reasonText {
    return DrivenText(text: siteFilter.label);
  }

  Widget get _selectionButton {
    if (siteFilter.keys.contains(SLInternalText.viewMoreKey)) {
      return const SizedBox();
    } else {
      return isRadioButton ? _radioButton : _checkBox;
    }
  }

  Widget get _radioButton => Obx(
        () => RadioIconView(
          isSelected: _isSelected,
        ),
      );

  Widget get _checkBox => Obx(
        () => SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            onChanged: (_) => _onTap(),
            value: _isSelected,
          ),
        ),
      );

  void _onTap() {
    _controller.onFilterOptionSelected(
      isRadioButton: isRadioButton,
      siteFilter: siteFilter,
    );
  }

  bool get _isSelected => _controller.selectedFilterKeysBeforeApplying.any(
        (list) => _controller.equality.equals(list, siteFilter.keys),
      );

  bool get _viewMoreWidget =>
      siteFilter.keys.contains(SLInternalText.viewMoreKey);

  IconData? getIconFromCode(int codePoint) {
    switch (codePoint) {
      case 0xf17c:
        return Icons.local_gas_station_outlined;
      case 0xf18e:
        return Icons.local_shipping_outlined;
      case 0xe050:
        return Icons.add_circle_outline;
      case 0xf3ef:
        return Icons.storefront_outlined;
      case 0xef57:
        return Icons.clear_all_outlined;
      case 0xe532:
        return Icons.restaurant;
      case 0xf4be:
        return Icons.wc_outlined;
      case 0xf383:
        return Icons.shower_outlined;
      case 0xf176:
        return Icons.local_car_wash_outlined;
      case 0xf24e:
        return Icons.paid_outlined;
      case 0xf312:
        return Icons.request_quote_outlined;
      case 0xf2a9:
        return Icons.pin_drop_outlined;
      case 0xe57f:
        return Icons.settings;
      case 0xf0564:
        return Icons.scale;
      case 0xf10e:
        return Icons.hotel_outlined;
      case 0xe394:
        return Icons.local_gas_station;
      default:
        return null;
    }
  }
}
