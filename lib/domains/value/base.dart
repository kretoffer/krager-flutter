abstract class BaseValueObject<T>{
  final T value;

  BaseValueObject(this.value){validate();}

  void validate();

  T asGenericType();
}