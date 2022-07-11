import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  String title = '';
  bool isCheck = false;
  ValueSetter<bool>? onChange;
  bool isAction;
  Color? color;

  CustomCheckBox(
      {Key? key,
        required this.title,
        this.onChange,
        required this.isCheck,
        this.color,
        this.isAction = true})
      : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChange == null
          ? null
          : () {
        setState(() {
          widget.isCheck = !widget.isCheck;
          widget.onChange!(widget.isCheck);
        });
      },
      child: Container(
        height: 20,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color:  widget.color == null
                      ? widget.isAction
                      ? Colors.white
                      : const Color(0xffDBDFEF).withOpacity(0.3)
                      : widget.color,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(
                    color: const Color(0xffDBDFEF),
                    width: 1.0,
                  )),
              width: 20,
              height: 20,
              child: Checkbox(
                  checkColor: Colors.white, // color of tick Mark
                  activeColor: const Color(0xff7966FF),
                  value: widget.isCheck,
                  onChanged: (value) {
                    if (widget.onChange != null) {
                      widget.isCheck = value ?? false;
                      setState(() {});
                      widget.onChange!(widget.isCheck);
                    }
                  }),
            ),
            SizedBox(
              width: widget.title.isEmpty ? 0 : 12,
            ),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: widget.isAction
                      ? const Color(0xff304261)
                      : Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}