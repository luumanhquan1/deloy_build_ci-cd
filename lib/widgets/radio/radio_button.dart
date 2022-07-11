import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/config/themes/app_theme.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/material.dart';

class RadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Function(T?) onChange;
  final String title;

  const RadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChange,
    this.title = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(value);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Radio<T>(
                fillColor: MaterialStateColor.resolveWith((states) {
                  if (states.isEmpty) {
                    return radioUnfocusColor;
                  }
                  return radioFocusColor;
                }),
                value: value,
                groupValue: groupValue,
                onChanged: (value) {
                  onChange(value);
                },
              ),
            ),
            const SizedBox(
              width: 13,
            ),
            Text(
              title,
              style: textNormal(
                AppTheme.getInstance().titleColor(),
                14.0.textScale(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
