import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:equatable/equatable.dart';

class EnhancedFilterModel extends Equatable {
  final String filterHeader;
  final ServiceTypeEnum serviceType;
  final List<SiteFilter> filterItems;

  const EnhancedFilterModel({
    required this.filterHeader,
    required this.serviceType,
    required this.filterItems,
  });

  factory EnhancedFilterModel.clone(EnhancedFilterModel model) =>
      EnhancedFilterModel(
        filterHeader: model.filterHeader,
        serviceType: model.serviceType,
        filterItems: model.filterItems.map(SiteFilter.clone).toList(),
      );

  @override
  List<Object?> get props => [
        filterHeader,
        serviceType,
        filterItems,
      ];
}
