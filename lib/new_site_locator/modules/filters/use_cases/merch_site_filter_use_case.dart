part of sl_filter_module;

class MerchSiteFilterUseCase
    extends BaseUseCase<List<SiteLocation>, MerchSiteFilterParam> {
  @override
  List<SiteLocation> execute(MerchSiteFilterParam param) {
    final List<SiteLocation> filteredLocations = [];
    final List<SiteLocation> siteLocations = param.siteLocations;
    final filters = param.filters;
    final isGallonUpFilterSelected = param.isGallonUpFilterSelected;
    final visibleBrandFilterKeys = param.visibleBrandFilterKeys;
    bool isFilterLoopApplied = false;

    filters.removeWhere((_, value) => value.isEmpty);

    if (filters.isEmpty) {
      return param.siteLocations;
    }

    if (isGallonUpFilterSelected) {
      isFilterLoopApplied = true;
      final filterList = siteLocations
          .where((e) =>
              e.amenities?.contains(SLInternalText.gallonUpFeeKey) ?? false)
          .toList();
      filteredLocations.addAll(filterList);
    }

    for (final filter in filters.entries) {
      final subFilters = filter.value;

      if (filter.key == SLInternalText.brandKey) {
        isFilterLoopApplied = true;
        final hasAllOthers = subFilters.any((subFilter) =>
            subFilter.any((element) => element == SLInternalText.allOthers));

        final list =
            filteredLocations.isEmpty ? siteLocations : filteredLocations;
        final subFilterLocation = <SiteLocation>[];

        if (hasAllOthers) {
          final filterList = list
              .where((e) => !visibleBrandFilterKeys
                  .containsIgnoreCase((e.brandName ?? '').toLowerCase()))
              .toList();

          subFilterLocation.addAll(filterList);
        }

        for (final subFilter in subFilters) {
          if (subFilter.contains(SLInternalText.allOthers)) {
            continue;
          }
          for (final _subFilter in subFilter) {
            final filterList = list
                .where((e) =>
                    e.brandName?.toLowerCase() == _subFilter.toLowerCase())
                .toList();
            subFilterLocation.addAll(filterList);
          }
        }

        if (filteredLocations.isNotEmpty) {
          filteredLocations.clear();
        }
        filteredLocations.addAll(subFilterLocation);
      }

      /// Archive code for future reference.
      // if (filter.key == SLInternalText.brandKey) {
      //   isFilterLoopApplied = true;
      //   final list =
      //       filteredLocations.isEmpty ? siteLocations : filteredLocations;
      //   final subFilterLocation = <SiteLocation>[];

      //   for (final subFilter in subFilters) {
      //     for (final _subFilter in subFilter) {
      //       final filterList = list
      //           .where((e) =>
      //               e.brandName?.toLowerCase() == _subFilter.toLowerCase())
      //           .toList();
      //       subFilterLocation.addAll(filterList);
      //     }
      //   }

      //   if (filteredLocations.isNotEmpty) {
      //     filteredLocations.clear();
      //   }
      //   filteredLocations.addAll(subFilterLocation);
      // }
      else if (filter.key != SLInternalText.fuelKey &&
          filter.key != SLInternalText.primaryBusinessKey &&
          filter.key != SLInternalText.brandKey) {
        isFilterLoopApplied = true;
        final list =
            filteredLocations.isEmpty ? siteLocations : filteredLocations;
        final subFilterLocation = <SiteLocation>[];

        for (final subFilter in subFilters) {
          for (final _subFilter in subFilter) {
            final filterList = list
                .where((e) => e.amenities?.contains(_subFilter) ?? false)
                .toList();
            subFilterLocation.addAll(filterList);
          }
        }

        if (filteredLocations.isNotEmpty) {
          filteredLocations.clear();
        }
        filteredLocations.addAll(subFilterLocation);
      }
    }

    return isFilterLoopApplied
        ? removeDuplicatesById(filteredLocations)
        : param.siteLocations;
  }

  List<SiteLocation> removeDuplicatesById(List<SiteLocation> items) {
    final uniqueMap = <String, SiteLocation>{};

    for (final item in items) {
      uniqueMap.putIfAbsent(item.masterIdentifier ?? '', () => item);
    }

    return uniqueMap.values.toList();
  }
}

class MerchSiteFilterParam {
  final List<SiteLocation> siteLocations;
  final Map<String, List<List<String>>> filters;
  final bool isGallonUpFilterSelected;
  final List<String> visibleBrandFilterKeys;

  MerchSiteFilterParam({
    required this.siteLocations,
    required this.filters,
    required this.isGallonUpFilterSelected,
    required this.visibleBrandFilterKeys,
  });
}
