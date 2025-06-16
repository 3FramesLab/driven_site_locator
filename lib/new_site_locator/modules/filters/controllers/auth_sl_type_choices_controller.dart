part of sl_filter_module;

class AuthSLTypeChoicesController extends GetxController {
  static final entitlementRepository = SiteLocatorEntitlementUtils.instance;

  //Selected site filter keys for each filter {'filter_key/service_type': ['site_filter_key1', 'site_filter_key1']}
  final RxMap<String, List<List<String>>> selectedSiteFiltersKeysMap =
      <String, List<List<String>>>{}.obs;

  final RxList<SiteFilter> brandSiteFilterList = <SiteFilter>[].obs;
  final RxList<SiteFilter> filteredBrandSiteFilterList = <SiteFilter>[].obs;
  final RxList<Filter> authFilterList = <Filter>[].obs;
  final RxList<NewSiteFilter> filterDisplayList = <NewSiteFilter>[].obs;
  final RxString searchedBrandText = ''.obs;
  final RxString selectedFilterHeader = ''.obs;
  final RxList<List<String>> selectedFilterKeysBeforeApplying =
      <List<String>>[].obs;
  final RxBool gallonUpSwitchValue = false.obs;
  final RxBool selectedFilterIsViewMoreClicked = false.obs;

  int selectedFilterViewMoreIndex = -1;
  List<NewSiteFilter> selectedFiltersAllFilters = [];
  bool isGallonUpFilterSelected = false;
  final List<String> visibleBrandFilterKeys = [];

  final searchBrandEditingController = TextEditingController();
  final equality = const DeepCollectionEquality();

  final viewMoreFilterClickUseCase = ViewMoreFilterClickUseCase();
  final filterOptionClickUseCase = FilterOptionClickUseCase();

  SiteFilter selectAllBrandsFilter = SiteFilter(
    key: SLInternalText.selectAllBrandsKey,
    label: SLViewText.selectAll,
    serviceType: ServiceTypeEnum.none,
    order: 0,
    type: FilterTypeEnum.quickFilter,
  );

  //To update the filter list fetched from json
  Future<void> updateAuthFilterList() async {
    authFilterList([...UmaSLProperties.filters]);
    _setVisibleBrandFilterKeys();

    if (DcSiteLocatorUtils.isGuest &&
        entitlementRepository.isCardTypeFilterEnabled) {
      authFilterList.insert(
        0,
        Filter(
          key: SLInternalText.cardTypeKey,
          quickFilterLabel: SLViewText.cardType,
          subFilterHeader: SLViewText.cardType,
          radioButton: true,
          hasGallonUpToggleButton: false,
          filters: [],
        ),
      );
    }
  }

  void setSLTypeSelected(String filterHeader) {
    selectedFilterHeader(filterHeader);
  }

  void setDefaultSLType() {
    selectedFilterHeader('');
  }

  void buttonActionHandler(Filter item) {
    setSLTypeSelected(item.key);
  }

  // Legacy code - when we want to apply filter immediately on selection of filter item.
  //On site filter click in modal bottom sheet
  // void onSiteFilterClick(NewSiteFilter siteFilter) {
  //   bool invokeApi = false;
  //   final parentFilter = authFilterList().firstWhereOrNull((e) {
  //     final subFilers =
  //         e.filters.firstWhereOrNull((e) => e.key == siteFilter.key);
  //     return subFilers != null;
  //   });
  //   final parentFilterKey = parentFilter?.key;
  //   final isRadioButton = parentFilter?.radioButton ?? false;

  //   final siteFiltersKeys = selectedSiteFiltersKeysMap[parentFilterKey];

  //   siteFilter.isSelected = !siteFilter.isSelected;

  //   if (parentFilterKey == SLInternalText.fuelKey) {
  //     DcSiteLocatorUtils.isFuelFilterSelectedSeparately = true;
  //   }

  //   if (isRadioButton) {
  //     // single check in a group.
  //     final existingSelectedSubFilters =
  //         selectedSiteFiltersKeysMap[parentFilterKey];
  //     if (existingSelectedSubFilters != null &&
  //         existingSelectedSubFilters.isNotEmpty) {
  //       if (!existingSelectedSubFilters.contains(siteFilter.key)) {
  //         invokeApi = true;
  //         selectedSiteFiltersKeysMap[parentFilterKey!] = [siteFilter.key];
  //       }
  //     } else {
  //       invokeApi = true;
  //       selectedSiteFiltersKeysMap[parentFilterKey!] = [siteFilter.key];
  //     }
  //   } else {
  //     // multiple check in a group.
  //     if (siteFiltersKeys != null && siteFiltersKeys.isNotEmpty) {
  //       int siteFilterPresentIndex = -1;
  //       for (int i = 0; i < siteFiltersKeys.length; i++) {
  //         if (siteFiltersKeys[i] == siteFilter.key) {
  //           siteFilterPresentIndex = i;
  //           break;
  //         }
  //       }
  //       if (siteFilterPresentIndex != -1) {
  //         selectedSiteFiltersKeysMap[parentFilterKey]!
  //             .removeAt(siteFilterPresentIndex);
  //       } else {
  //         selectedSiteFiltersKeysMap[parentFilterKey]!.add(siteFilter.key);
  //       }
  //     } else {
  //       selectedSiteFiltersKeysMap[parentFilterKey!] = [siteFilter.key];
  //     }
  //   }
  //   selectedSiteFiltersKeysMap.removeWhere((_, value) => value.isEmpty);
  //   selectedSiteFiltersKeysMap.refresh();

  //   if (parentFilterKey == SLInternalText.fuelKey) {
  //     DcSiteLocatorUtils.isGenerateMapPinsOnFiltering(value: true);
  //   }

  //   if (isRadioButton) {
  //     if (invokeApi) {
  //       callMerchSitesOnFilter();
  //     }
  //   } else {
  //     applyMerchFilters();
  //   }
  // }

  Future<void> callMerchSitesOnFilter() async {
    await DcSiteLocatorUtils.callMerchSitesOnFilterChange();
  }

  Future<void> applyMerchFilters() async {
    DcSiteLocatorUtils.applyMerchFilters();
  }

  // TODO(Smeet): uncomment below line if you want to call the filter change API
  // Map<String, dynamic> getFilterJson() {
  //   final Map<String, dynamic> filterJsonData = {};

  //   if (selectedSiteFiltersKeysMap.isNotEmpty) {
  //     for (final entry in selectedSiteFiltersKeysMap().entries) {
  //       final key = entry.key;
  //       final value = entry.value;
  //       if (key == SLInternalText.fuelKey) {
  //         filterJsonData[SLInternalText.productTypeParam] = value.join(', ');
  //       } else if (key == SLInternalText.brandKey ||
  //           key == SLInternalText.primaryBusinessKey) {
  //       } else if (value.isNotEmpty) {
  //         filterJsonData[SLInternalText.amenitiesParam] = value.join(', ');
  //       }
  //     }
  //   }

  //   return filterJsonData;
  // }

  // Legacy code - brand filter page.
  // fetch brand sitefilter, check if it is selected and move to brand filter page
  // void moveToBrandFilterPage() {
  //   if (brandSiteFilterList().isEmpty) {
  //     final brandFilter = authFilterList
  //         .firstWhereOrNull((e) => e.key == SLInternalText.brandKey);
  //     if (brandFilter != null) {
  //       brandSiteFilterList.addAll(brandFilter.filters
  //           .where((e) => UmaSLProperties.topFuelBrands.contains(e.key))
  //           .toList());

  //       final noTopBrands = brandFilter.filters
  //           .where((e) => !UmaSLProperties.topFuelBrands.contains(e.key))
  //           .toList();

  //       noTopBrands.sort(
  //           (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

  //       brandSiteFilterList.addAll(noTopBrands);
  //     }

  //     brandSiteFilterList.insert(0, selectAllBrandsFilter);
  //   }

  //   selectAllBrandsFilter.isChecked = true;
  //   for (final i in brandSiteFilterList) {
  //     if (i.key == SLInternalText.selectAllBrandsKey) {
  //       continue;
  //     }
  //     if (i.isSelected) {
  //       i.isChecked = true;
  //     } else {
  //       selectAllBrandsFilter.isChecked = false;
  //       i.isChecked = false;
  //     }
  //   }
  //   searchBrandEditingController.clear();
  //   searchedBrandText('');
  //   NavTo.brandQuickFilter();
  // }

  void updateBrandFiltersChecked() {
    final List<String> brandSiteFilterKeyList = [];
    if (selectAllBrandsFilter.isChecked) {
      for (final brandSite in brandSiteFilterList) {
        if (brandSite.key != SLInternalText.selectAllBrandsKey) {
          brandSite.isChecked = true;
          brandSite.isSelected = true;
          brandSiteFilterKeyList.add(brandSite.key);
        }
      }
    } else {
      for (final brandSite in brandSiteFilterList) {
        if (brandSite.key != SLInternalText.selectAllBrandsKey) {
          if (brandSite.isChecked) {
            brandSite.isSelected = true;
            brandSiteFilterKeyList.add(brandSite.key);
          } else {
            brandSite.isSelected = false;
          }
        }
      }
    }
    selectedSiteFiltersKeysMap.removeWhere((_, value) => value.isEmpty);
    selectedSiteFiltersKeysMap.refresh();
    Get.back();
    applyMerchFilters();
  }

  //Back to map page from brand quick filter page
  void backToMapPage() {
    for (final i in brandSiteFilterList) {
      i.isChecked = false;
    }
    Get.back();
  }

  //On site filter selection in brand quick filter page
  void onBrandSiteFilterSelect(SiteFilter siteFilter) {
    siteFilter.isChecked = !siteFilter.isChecked;

    if (siteFilter.key == SLInternalText.selectAllBrandsKey) {
      onBrandSiteFilterSelectAll(isChecked: siteFilter.isChecked);
    } else {
      if (!siteFilter.isChecked) {
        selectAllBrandsFilter.isChecked = false;
      }
    }
    brandSiteFilterList.refresh();
  }

  void onBrandSiteFilterSelectAll({required bool isChecked}) {
    for (final siteFilter in brandSiteFilterList) {
      siteFilter.isChecked = isChecked;
    }
  }

  List<SiteFilter> get displayBrandsList {
    if (searchedBrandText().isNotEmpty &&
        searchBrandEditingController.text.isNotEmpty) {
      selectAllBrandsFilter.isVisible = false;
      return filteredBrandSiteFilterList();
    }

    selectAllBrandsFilter.isVisible = true;
    return brandSiteFilterList();
  }

  bool isMerchFilterApplied() {
    return selectedSiteFiltersKeysMap.isNotEmpty;
    // if (selectAllBrandsFilter.isChecked) {
    //   return false;
    // } else {
    //   final value = selectedSiteFiltersKeysMap[SLInternalText.brandKey];
    //   if (value != null && value.isNotEmpty) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }
  }

  // Legacy code- brand filter page.
  // List<String> getFilterBrandKeys() {
  //   if (isBrandFilterApplied()) {
  //     final value = selectedSiteFiltersKeysMap[SLInternalText.brandKey];
  //     if (value != null && value.isNotEmpty) {
  //       return value;
  //     } else {
  //       return [];
  //     }
  //   } else {
  //     return [];
  //   }
  // }

  void resetFilters() {
    gallonUpSwitchValue(false);
    isGallonUpFilterSelected = false;
    selectedSiteFiltersKeysMap.clear();
    searchedBrandText('');
    searchBrandEditingController.clear();
    for (final element in brandSiteFilterList) {
      element.isChecked = false;
      element.isSelected = false;
    }
    authFilterList([...UmaSLProperties.filters]);
    selectAllBrandsFilter.isChecked = false;
    selectAllBrandsFilter.isVisible = true;
  }

  void setPrimaryBusinessFilter(String defaultBusiness) {
    final parentFilter = authFilterList().firstWhereOrNull((e) {
      final subFilers =
          e.filters.firstWhereOrNull((e) => e.keys.contains(defaultBusiness));
      return subFilers != null;
    });

    if (parentFilter != null) {
      selectedSiteFiltersKeysMap[parentFilter.key] = [
        [defaultBusiness]
      ];
      selectedSiteFiltersKeysMap.refresh();
    }
  }

  void setFuelFilter(String defaultFuel) {
    final parentFilter = authFilterList().firstWhereOrNull((e) {
      final subFilers =
          e.filters.firstWhereOrNull((e) => e.keys.contains(defaultFuel));
      return subFilers != null;
    });

    if (parentFilter != null) {
      selectedSiteFiltersKeysMap[parentFilter.key] = [
        [defaultFuel]
      ];
      selectedSiteFiltersKeysMap.refresh();
    }
  }

  void onParentFilterClick(Filter filter) {
    selectedFilterKeysBeforeApplying().clear();
    if (filter.hasGallonUpToggleButton) {
      gallonUpSwitchValue(isGallonUpFilterSelected);
    }
    if (selectedSiteFiltersKeysMap.isNotEmpty &&
        selectedSiteFiltersKeysMap[filter.key] != null) {
      selectedFilterKeysBeforeApplying()
          .addAll(selectedSiteFiltersKeysMap[filter.key]!);
    }
  }

  void onFilterOptionSelected({
    required NewSiteFilter siteFilter,
    required bool isRadioButton,
  }) {
    if (siteFilter.keys.contains(SLInternalText.viewMoreKey)) {
      _onViewMoreClick(siteFilter: siteFilter);
    } else {
      filterOptionClickUseCase.execute(
        FilterOptionClickParam(
          isRadioButton: isRadioButton,
          selectedFilterKeysBeforeApplying: selectedFilterKeysBeforeApplying,
          siteFilter: siteFilter,
          equality: equality,
        ),
      );
    }
  }

  void _onViewMoreClick({
    required NewSiteFilter siteFilter,
  }) {
    viewMoreFilterClickUseCase.execute(
      ViewMoreFilterClickParam(
        selectedFilterIsViewMoreClicked: selectedFilterIsViewMoreClicked(),
        filterDisplayList: filterDisplayList,
        selectedFiltersAllFilters: selectedFiltersAllFilters,
        selectedFilterViewMoreIndex: selectedFilterViewMoreIndex,
      ),
    );

    selectedFilterIsViewMoreClicked.value = !selectedFilterIsViewMoreClicked();
    filterDisplayList.refresh();
  }

  void onApplyFilterClick(Filter filter) {
    final key = filter.key;
    if (filter.hasGallonUpToggleButton) {
      isGallonUpFilterSelected = gallonUpSwitchValue();
    }
    if (selectedFilterKeysBeforeApplying.isEmpty) {
      selectedSiteFiltersKeysMap.remove(key);
    } else {
      selectedSiteFiltersKeysMap[key] = [...selectedFilterKeysBeforeApplying];
    }

    if (key == SLInternalText.fuelKey) {
      DcSiteLocatorUtils.isFuelFilterSelectedSeparately = true;
    }

    Get.back();
    if (filter.radioButton) {
      // if (invokeApi) {
      callMerchSitesOnFilter();
      // }
    } else {
      applyMerchFilters();
    }
  }

  void onClearFilterClick(Filter filter) {
    if (selectedSiteFiltersKeysMap.isNotEmpty &&
        selectedSiteFiltersKeysMap[filter.key] != null) {
      selectedSiteFiltersKeysMap.remove(filter.key);
    }

    if (filter.hasGallonUpToggleButton) {
      gallonUpSwitchValue(false);
      isGallonUpFilterSelected = false;
    }
    Get.back();
    applyMerchFilters();
  }

  void setFilterListOnParentFilterClick(Filter filter) {
    final List<NewSiteFilter> filterListOptions = [];
    selectedFilterIsViewMoreClicked(false);
    selectedFiltersAllFilters =
        filter.filters.where((e) => e.isVisible).toList();

    selectedFilterViewMoreIndex = selectedFiltersAllFilters
        .indexWhere((e) => e.keys.contains(SLInternalText.viewMoreKey));

    if (selectedFilterViewMoreIndex >= 0) {
      // Does contain view more
      filterListOptions.addAll(
        selectedFiltersAllFilters.sublist(0, selectedFilterViewMoreIndex + 1),
      );
    } else {
      // Does not contain view more
      filterListOptions.addAll(selectedFiltersAllFilters);
    }

    filterDisplayList.value =
        filterListOptions.map(NewSiteFilter.clone).toList();
    filterDisplayList.refresh();
  }

  void _setVisibleBrandFilterKeys() {
    final brandFilter = authFilterList
        .firstWhereOrNull((e) => e.key == SLInternalText.brandKey);
    visibleBrandFilterKeys.clear();
    if (brandFilter != null) {
      final list = brandFilter.filters
          .where((f) => f.isVisible)
          .expand((f) => f.keys)
          .toList();
      list.removeWhere((e) => e == SLInternalText.viewMoreKey);
      visibleBrandFilterKeys.assignAll(list);
    }
  }
}
