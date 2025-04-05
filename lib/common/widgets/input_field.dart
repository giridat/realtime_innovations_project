import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realtime_innovations_project/common/input_field_model.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.inputModel,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
    required this.inputFormatters,
    required this.autofillHints,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    super.key,
  });

  final InputFieldModel inputModel;
  final FocusNode focusNode;
  final bool enabled;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool obscureText;
  final Set<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTapOutside: (_)=>focusNode.unfocus(),
      inputFormatters: inputFormatters.toList(),
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Background color
        hintText: inputModel.value.labelText, // Use label from model
        hintStyle: TextStyle(
          color: Color.fromRGBO(148, 156, 158, 1),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Color.fromRGBO(229, 229, 229, 1), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        prefixIcon: const Icon(
          Icons.person_outline,
          color: Colors.blue,
        ),
        errorText: inputModel.showError ? inputModel.errorMessage : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      onChanged: onChanged,
      onFieldSubmitted: (value) {
        onFieldSubmitted?.call(value);
        focusNode.unfocus();
      },
    );
  }
}
