import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:ccvc_mobile/widgets/textformfield/form_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldValidator extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final bool isEnabled;
  final Function(String)? onChange;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final TextInputType? textInputType;
  final int maxLine;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final Color? fillColor;

  const TextFieldValidator({
    Key? key,
    this.controller,
    this.isEnabled = true,
    this.onChange,
    this.validator,
    this.initialValue,
    this.maxLine = 1,
    this.textInputType,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.obscureText,
    this.fillColor,
  }) : super(key: key);

  @override
  State<TextFieldValidator> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFieldValidator> {
  final key = GlobalKey<FormState>();
  FormProvider? formProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    formProvider = FormProvider.of(context);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (formProvider != null) {
        if (widget.validator != null) {
          final validator =
              widget.validator!(widget.controller?.text ?? '') == null;
          formProvider?.validator.addAll({key: validator});
        } else {
          formProvider?.validator.addAll({key: true});
        }
      }
    });
    if (formProvider != null) {
      formProvider?.validator.addAll({key: true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        onChanged: (value) {
          if (formProvider != null) {
            formProvider?.validator[key] = key.currentState!.validate();
          }
          if (widget.onChange != null) {
            widget.onChange!(value);
          }
        },
        initialValue: widget.initialValue,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLine,
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        style: tokenDetailAmount(
          fontSize: 14.0.textScale(),
          color: titleColor,
        ),
        enabled: widget.isEnabled,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textNormal(titleItemEdit.withOpacity(0.5), 14),
          contentPadding: widget.maxLine == 1
              ? const EdgeInsets.symmetric(vertical: 14, horizontal: 10)
              : null,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          fillColor: widget.isEnabled
              ? widget.fillColor ?? Colors.transparent
              : borderColor.withOpacity(0.3),
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(value);
          }
        },
      ),
    );
  }
}
