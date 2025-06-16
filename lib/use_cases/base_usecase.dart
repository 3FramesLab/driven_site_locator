// ignore_for_file: one_member_abstracts

abstract class BaseUseCase<T, Param> {
  const BaseUseCase();

  T execute(Param param);
}

abstract class BaseNoParamUseCase<T> {
  const BaseNoParamUseCase();

  T execute();
}
