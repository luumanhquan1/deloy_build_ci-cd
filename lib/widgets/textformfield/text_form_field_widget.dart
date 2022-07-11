import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final bool isEnabled;
  final Function(String)? onChange;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final int maxLine;

  const TextFormFieldWidget({
    Key? key,
    this.controller,
    required this.isEnabled,
    this.onChange,
    this.validator,
    this.initialValue,
    this.maxLine = 1,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChange,
      initialValue: initialValue,
      keyboardType: textInputType,
      maxLines: maxLine,
      style: tokenDetailAmount(
        fontSize: 14.0.textScale(),
        color: titleColor,
      ),
      enabled: isEnabled,
      decoration: InputDecoration(
        contentPadding: maxLine == 1
            ? const EdgeInsets.symmetric(vertical: 14, horizontal: 10)
            : null,
        fillColor:
            isEnabled ? Colors.transparent : borderColor.withOpacity(0.3),
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      validator: validator,
    );
  }
}
