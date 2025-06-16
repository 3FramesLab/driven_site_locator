// ignore_for_file: must_be_immutable, unnecessary_lambdas

part of site_locator_module;

class Filter {
  String quickFilterLabel;
  String subFilterHeader;
  String key;
  bool radioButton;
  bool hasGallonUpToggleButton;
  List<NewSiteFilter> filters;

  Filter({
    required this.key,
    required this.quickFilterLabel,
    required this.subFilterHeader,
    required this.radioButton,
    required this.hasGallonUpToggleButton,
    required this.filters,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      key: json['key'],
      quickFilterLabel: json['quick_filter_label'],
      subFilterHeader: json['sub_filter_header'],
      radioButton: json['radioButton'] ?? false,
      hasGallonUpToggleButton: json['hasGallonUpToggleButton'] ?? false,
      filters: _convertToSiteFilter(json['filters']),
    );
  }

  static List<NewSiteFilter> _convertToSiteFilter(dynamic value) {
    if (value != null && value is List) {
      final siteFilters = value.map((e) => NewSiteFilter.fromJson(e)).toList();
      // siteFilters.sort((a, b) => a.label.compareTo(b.label));
      return siteFilters;
    }
    return [];
  }
}

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

class NewSiteFilter extends Equatable {
  final FilterTypeEnum? type;
  List<String> keys;
  late final String label;
  final ServiceTypeEnum? serviceType;
  final int order;
  bool isChecked; // temporary check /// final check
  final bool isTopVisible;
  final List<String> flavors;
  bool isVisible;
  bool isSelected; // final check /// temporary check
  String icon;

  NewSiteFilter({
    required this.type,
    required this.keys,
    required this.label,
    required this.serviceType,
    required this.order,
    this.isChecked = false,
    this.isTopVisible = false,
    this.flavors = const [],
    this.isVisible = true,
    this.isSelected = false,
    this.icon = '',
  });

  factory NewSiteFilter.fromJson(Map<String, dynamic> json) {
    return NewSiteFilter(
      type: json['type'] != null
          ? filterTypeValues.map[json['type']]
          : FilterTypeEnum.quickFilter,
      keys: (json['key'] as List).map((e) => e.toString()).toList(),
      label: json['label'],
      serviceType: json['serviceType'] == null
          ? ServiceTypeEnum.none
          : serviceTypeValues.map[json['serviceType']],
      order: json['order'] ?? 0,
      flavors: json['flavors'] != null
          ? (json['flavors'] as List).map((e) => e.toString()).toList()
          : [],
      isVisible: json['isVisible'] ?? true,
      icon: json['icon'] ?? '',
    );
  }

  factory NewSiteFilter.clone(NewSiteFilter filter) => NewSiteFilter(
        type: filter.type,
        keys: filter.keys,
        label: filter.label,
        serviceType: filter.serviceType,
        order: filter.order,
        isChecked: filter.isChecked,
        isTopVisible: filter.isTopVisible,
        flavors: filter.flavors,
        isVisible: filter.isVisible,
        isSelected: filter.isSelected,
        icon: filter.icon,
      );

  /// To compare [NewSiteFilter] objects
  /// only [keys] property will be used.
  @override
  List<Object?> get props => [
        keys,
      ];
}

class SiteFilter extends Equatable {
  final FilterTypeEnum? type;
  String key;
  late final String label;
  final ServiceTypeEnum? serviceType;
  final int order;
  bool isChecked; // temporary check /// final check
  final bool isTopVisible;
  final List<String> flavors;
  bool isVisible;
  bool isSelected; // final check /// temporary check
  String icon;
  String iconCode;

  SiteFilter({
    required this.type,
    required this.key,
    required this.label,
    required this.serviceType,
    required this.order,
    this.isChecked = false,
    this.isTopVisible = false,
    this.flavors = const [],
    this.isVisible = true,
    this.isSelected = false,
    this.icon = '',
    this.iconCode = '',
  });

  factory SiteFilter.fromJson(Map<String, dynamic> json) {
    return SiteFilter(
      type: json['type'] != null
          ? filterTypeValues.map[json['type']]
          : FilterTypeEnum.quickFilter,
      key: json['key'],
      label: json['label'],
      serviceType: json['serviceType'] == null
          ? ServiceTypeEnum.none
          : serviceTypeValues.map[json['serviceType']],
      order: json['order'] ?? 0,
      flavors: json['flavors'] != null
          ? (json['flavors'] as List).map((e) => e.toString()).toList()
          : [],
      isVisible: json['isVisible'] ?? true,
      icon: json['icon'] ?? '',
      iconCode: json['iconCode'] ?? '',
    );
  }

  factory SiteFilter.clone(SiteFilter filter) => SiteFilter(
        type: filter.type,
        key: filter.key,
        label: filter.label,
        serviceType: filter.serviceType,
        isTopVisible: filter.isTopVisible,
        order: filter.order,
        isSelected: filter.isSelected,
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
