
import 'package:formz/formz.dart';
mixin ValidationErrorMessage {
  String? get errorMessage;
  bool get showError;
}

abstract class InputFieldValue<Val extends Object> {
  String get labelText;
  String? get helperText;
  String? get serverErrorText;
  bool? get showServerError;
  bool get isOptional;
  bool get skipValidation;
  Val get inputValue;
}

abstract class PinPutFieldValue<Val extends Object> {
  Val get otpValue;
  String? get serverErrorText;
  bool? get showServerError;
  bool get isOptional;
  bool get skipValidation;
}

abstract class InputFieldModel<Val extends InputFieldValue<Object>,
        Err extends Enum> extends FormzInput<Val, Err>
    with FormzInputErrorCacheMixin<Val, Err>, ValidationErrorMessage {
  InputFieldModel.pure(super.value) : super.pure();
  InputFieldModel.dirty(super.value) : super.dirty();
}
