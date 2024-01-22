// ignore_for_file: must_be_immutable, unnecessary_lambdas

import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/data/models/enum_values.dart';
import 'package:equatable/equatable.dart';

class EnhancedSiteFilter {
  final List<SiteFilter> amenities;
  final List<SiteFilter> locationFeatures;
  final List<SiteFilter> locationTypes;

  EnhancedSiteFilter({
    required this.amenities,
    required this.locationFeatures,
    required this.locationTypes,
  });

  factory EnhancedSiteFilter.fromJson(Map<String, dynamic> json) {
    return EnhancedSiteFilter(
      amenities: _convertToSiteFilter(json['amenities']),
      locationFeatures: _convertToSiteFilter(json['location_features']),
      locationTypes: _convertToSiteFilter(json['location_types']),
    );
  }

  static List<SiteFilter> _convertToSiteFilter(dynamic value) {
    if (value != null && value is List) {
      final siteFilters = value
          .map((e) => SiteFilter.fromJson(e))
          .where((element) => element.flavors.contains(AppUtils.flavor))
          .toList();
      siteFilters.sort((a, b) => a.label.compareTo(b.label));
      return siteFilters;
    }
    return [];
  }
}

class SiteFilter extends Equatable {
  final FilterTypeEnum? type;
  String key;
  late final String label;
  final ServiceTypeEnum? serviceType;
  final int order;
  bool isChecked;
  final bool isTopVisible;
  final List<String> flavors;

  SiteFilter({
    required this.type,
    required this.key,
    required this.label,
    required this.serviceType,
    required this.order,
    this.isChecked = false,
    this.isTopVisible = false,
    this.flavors = const [],
  });

  factory SiteFilter.fromJson(Map<String, dynamic> json) {
    return SiteFilter(
      type: filterTypeValues.map[json['type']],
      key: json['key'],
      label: json['label'],
      serviceType: serviceTypeValues.map[json['serviceType']],
      order: json['order'],
      flavors: (json['flavors'] as List).map((e) => e.toString()).toList(),
    );
  }

  factory SiteFilter.clone(SiteFilter filter) => SiteFilter(
        type: filter.type,
        key: filter.key,
        label: filter.label,
        serviceType: filter.serviceType,
        isTopVisible: filter.isTopVisible,
        order: filter.order,
      );

  /// To compare [SiteFilter] objects
  /// only [key] property will be used.
  @override
  List<Object?> get props => [
        key,
      ];
}

enum FilterTypeEnum {
  quickFilter('quickFilter'),
  enhancedFilter('enhancedFilter'),
  preferredFilter('preferredFilter');

  const FilterTypeEnum(this.value);
  final String value;
}

final filterTypeValues = EnumValues({
  'quickFilter': FilterTypeEnum.quickFilter,
  'enhancedFilter': FilterTypeEnum.enhancedFilter,
  'preferredFilter': FilterTypeEnum.preferredFilter,
});

enum ServiceTypeEnum {
  amenities('amenities'),
  features('features'),
  fuelType('fuelType'),
  locationType('locationType'),
  fuelBrand('fuelBrand'),
  none('none');

  const ServiceTypeEnum(this.value);
  final String value;
}

final serviceTypeValues = EnumValues({
  'amenities': ServiceTypeEnum.amenities,
  'features': ServiceTypeEnum.features,
  'fuelType': ServiceTypeEnum.fuelType,
  'locationType': ServiceTypeEnum.locationType,
  'fuelBrand': ServiceTypeEnum.fuelBrand,
  'none': ServiceTypeEnum.none,
});
