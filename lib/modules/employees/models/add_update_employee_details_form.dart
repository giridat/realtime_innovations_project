import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:realtime_innovations_project/common/input_field_model.dart';

import 'name_input_field_model_value.dart';

part 'add_update_employee_details_form.freezed.dart';

@freezed
class AddUpdateEmployeeDetailsForm
    with _$AddUpdateEmployeeDetailsForm, FormzMixin {
  factory AddUpdateEmployeeDetailsForm({
    required NameInputField name,
  }) = _AddUpdateEmployeeDetailsForm;

  const AddUpdateEmployeeDetailsForm._();

  factory AddUpdateEmployeeDetailsForm.pure() {
    return AddUpdateEmployeeDetailsForm(
      name: NameInputField.pure(NameInputFieldModelValue()),
    );
  }

  @override
  List<InputFieldModel> get inputs => [name];

  @override
  NameInputField get name => (this).name;
}
