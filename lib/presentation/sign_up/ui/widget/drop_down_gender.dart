import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:flutter/material.dart';

class DropDownGender extends StatefulWidget {
  final List<String> items;
  final String? initData;
  final Function(String value) onChange;

  const DropDownGender({
    Key? key,
    required this.items,
    required this.onChange,
    this.initData,
  }) : super(key: key);

  @override
  State<DropDownGender> createState() => _DropDownGenderState();
}

class _DropDownGenderState extends State<DropDownGender> {
  String dropDownValue = '';

  @override
  void initState() {
    super.initState();
    if (widget.initData == null) {
      dropDownValue = widget.items[0];
    } else {
      dropDownValue = widget.initData ?? widget.items[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropDownValue,
          onChanged: (value) {
            dropDownValue = value ?? '';
            widget.onChange(value ?? '');
            setState(() {});
          },
          items: widget.items
              .map<DropdownMenuItem<String>>(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      item,
                      style: textNormal(selectColorTabbar, 14),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
