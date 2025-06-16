part of map_view_module;

class GetWelcomeScreenInfoUseCase extends BaseNoParamUseCase<String> {
  @override
  String execute() => AppUtils.isComdata
      ? AppStrings.comdataWelcomeScreenInfo
      : AppStrings.fuelmanWelcomeScreenInfo;
}
