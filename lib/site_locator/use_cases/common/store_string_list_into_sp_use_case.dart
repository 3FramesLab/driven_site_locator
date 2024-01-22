import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';

class StoreStringListIntoSPUseCase
    extends BaseFutureUseCase<void, StoreStringListParams> {
  @override
  Future<void> execute(StoreStringListParams param) async =>
      PreferenceUtils.setStringList(
        param.key,
        value: param.value,
      );
}

class StoreStringListParams {
  final String key;
  final List<String> value;

  StoreStringListParams({required this.key, required this.value});
}
