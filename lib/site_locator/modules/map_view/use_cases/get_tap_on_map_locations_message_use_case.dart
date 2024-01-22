part of map_view_module;

class GetTapOnMapLocationMessageUseCase extends BaseNoParamUseCase<String> {
  @override
  String execute() => AppUtils.isComdata
      ? AppStrings.comdataTapOnMapLocations
      : AppStrings.fuelmanTapOnMapLocations;
}
