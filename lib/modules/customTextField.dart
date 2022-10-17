import 'package:flutter/material.dart';

class ReuseableTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputAction inputAction;
  final TextInputType textInputType;
  final String Function(String) validator;
  final Widget suffixWidget;
  final bool hasFocus;
  final int maxLines;
  final bool isEnable;
  final bool readOnly;
  final bool autovalidate;
  final bool edit;
  final Function() onCLick;
  final Function(String) onChanged;

  const ReuseableTextField({
    Key key,
     this.hintText,
    this.edit = false,
     this.isPassword,
     this.controller,
    this.inputAction = TextInputAction.next,
     this.validator,
    this.suffixWidget,
    this.hasFocus = true,
    this.isEnable = true,
    this.textInputType = TextInputType.name,
    this.maxLines = 1,
    this.onCLick,
    this.onChanged,
    this.autovalidate,
    this.readOnly = false,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      obscureText: isPassword,
      controller: controller,
      enabled: isEnable,
      enableInteractiveSelection: false,
      keyboardType: textInputType,
      textInputAction: inputAction,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      autovalidateMode: autovalidate == null
          ? AutovalidateMode.disabled
          : AutovalidateMode.onUserInteraction,
      onTap: onCLick,
      onChanged: onChanged,
      focusNode: hasFocus ? null : AlwaysDisabledFocusNode(),
      style:  theme.textTheme.caption.copyWith(
        color: const Color(0xFF4A4A4A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        alignLabelWithHint: true,
        fillColor: Colors.transparent,
        suffixIcon: suffixWidget,
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),

        suffixIconConstraints: BoxConstraints(
            minWidth: 0.0, minHeight: 0.0, maxHeight: 25.0, maxWidth: 40.0),
        labelText: labelText,
        labelStyle: theme.textTheme.bodyText1,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class AlwaysEnablesFocusNode extends FocusNode {
  @override
  bool get hasFocus => true;
}
