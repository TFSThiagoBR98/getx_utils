import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormfield extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final bool readOnly;
  final bool visible;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;
  final int? lines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  final TextInputType? keyboardType;

  final String? helperText;

  const InputFormfield(
      {Key? key,
      this.controller,
      this.onChanged,
      this.labelText,
      this.visible = true,
      this.prefixIcon,
      this.suffixIcon,
      this.lines,
      this.inputFormatters,
      this.validator,
      this.focusNode,
      this.obscureText = false,
      this.readOnly = false,
      this.keyboardType,
      this.helperText,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onTap: onTap,
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          minLines: lines,
          readOnly: readOnly,
          maxLines: lines,
          decoration: InputDecoration(
              suffixIcon: suffixIcon,
              border: const OutlineInputBorder(),
              prefixIcon: prefixIcon,
              helperText: helperText,
              labelText: labelText),
        ),
      ),
    );
  }
}
