import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';

class GetStringListFromSPUseCase
    extends BaseUseCase<List<String>?, GetStringListFromSPParams> {
  @override
  List<String>? execute(GetStringListFromSPParams param) =>
      PreferenceUtils.getStringList(
        param.key,
        defaultValue: [],
      );
}

class GetStringListFromSPParams {
  final String key;

  GetStringListFromSPParams({required this.key});
}
