part of filter_module;

class GetFuelTypeFiltersUseCase
    extends BaseUseCase<List<SiteFilter>, GetFuelTypeFiltersParams> {
  @override
  List<SiteFilter> execute(GetFuelTypeFiltersParams param) =>
      param.siteFiltersList
          .where((element) =>
              element.serviceType?.name == ServiceTypeEnum.fuelType.name)
          .toList();
}

class GetFuelTypeFiltersParams {
  List<SiteFilter> siteFiltersList;

  GetFuelTypeFiltersParams(this.siteFiltersList);
}
