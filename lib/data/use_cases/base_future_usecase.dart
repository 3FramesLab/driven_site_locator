import 'package:driven_site_locator/data/use_cases/base_usecase.dart';

abstract class BaseFutureUseCase<T, Param>
    extends BaseUseCase<Future<T>?, Param> {
  const BaseFutureUseCase();
}

abstract class BaseNoParamFutureUseCase<T>
    extends BaseNoParamUseCase<Future<T>> {
  const BaseNoParamFutureUseCase();
}
