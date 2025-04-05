import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:realtime_innovations_project/common/enums/field_validation_error.dart';
import 'package:realtime_innovations_project/common/input_field_model.dart';

part 'name_input_field_model_value.freezed.dart';

@freezed
class NameInputFieldModelValue
    with _$NameInputFieldModelValue
    implements InputFieldValue<String> {
  const factory NameInputFieldModelValue({
    String? value,
    String? hint,
    String? serverErrorMessage,
    @Default('Employee Name') String label,
    @Default(2) int minLength,
    @Default(100) int maxLength,
    @Default(false) bool skipValidationFlag,
    @Default(false) bool isOptionalFlag,
    @Default(false) bool showServerErrorFlag,
  }) = _NameInputFieldModelValue;

  const NameInputFieldModelValue._();

  @override
  String? get helperText => hint;

  @override
  String get inputValue => value ?? '';

  @override
  bool get isOptional => isOptionalFlag; // Reference the constructor parameter

  @override
  String get labelText => label;

  @override
  String? get serverErrorText => serverErrorMessage;

  @override
  bool? get showServerError => showServerErrorFlag;

  @override
  bool get skipValidation =>
      skipValidationFlag;

  @override
  String? get hint => helperText;

  @override
  bool get isOptionalFlag => isOptional;

  @override
  String get label => labelText;

  @override
  int get maxLength => (this).maxLength;

  @override
  int get minLength => (this).minLength;

  @override
  String? get serverErrorMessage => serverErrorText;

  @override
  bool get showServerErrorFlag => showServerError ?? false;

  @override
  bool get skipValidationFlag => skipValidation;

  @override
  String? get value => inputValue; // Reference the constructor parameter
}

class NameInputField
    extends InputFieldModel<NameInputFieldModelValue, NameInputError> {
  @override
  NameInputField.pure(super.value) : super.pure();

  @override
  NameInputField.dirty(super.value) : super.dirty();

  @override
  String? get errorMessage {
    final error = validator(value);

    switch (error) {
      case NameInputError.required:
        return 'Employee name is required';

      case null:
        return null;
      case NameInputError.nullValue:
        return 'Employee name is required';

      case NameInputError.empty:
        return 'Employee name is required';
      case NameInputError.tooShort:
        return 'Employee name should be at least 2 characters long';
      case NameInputError.tooLong:
        return 'Employee name should be at most 100 characters long';
      case NameInputError.errorPostServerRequest:
        return 'Something went wrong with the request';
      case NameInputError.serverErrorMessage:
        return 'Something went wrong';
    }
  }

  @override
  bool get showError => displayError != null;

  @override
  NameInputError? validator(NameInputFieldModelValue? value) {
    final isOptional = value?.isOptional ?? false;
    final isEmpty = value?.inputValue.isEmpty ?? true;

    if (isOptional && isEmpty) {
      return null;
    }

    if (value?.skipValidation ?? false) {
      return null;
    }

    if (value?.inputValue.isEmpty ?? true) {
      return NameInputError.required;
    }
    return null;
  }

  NameInputField copyWith({
    String? value,
    String? serverErrorText,
    bool? showServerError,
  }) {
    return NameInputField.dirty(
      this.value.copyWith(
            value: value ?? this.value.inputValue,
            serverErrorMessage: serverErrorText,
            showServerErrorFlag:
                showServerError ?? this.value.showServerErrorFlag,
          ),
    );
  }
}
