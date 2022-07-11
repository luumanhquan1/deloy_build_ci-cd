
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/presentation/sign_up/bloc/sign_up_cubit.dart';
import 'package:ccvc_mobile/utils/extensions/date_time_extension.dart';
import 'package:flutter/cupertino.dart';

class BirthDayWidget extends StatefulWidget {
  final SignUpCubit cubit;
  final Function(DateTime value) onChange;

  const BirthDayWidget({
    Key? key,
    required this.onChange,
    required this.cubit,
  }) : super(key: key);

  @override
  State<BirthDayWidget> createState() => _BirthDayWidgetState();
}

class _BirthDayWidgetState extends State<BirthDayWidget> {
  bool isShowDateTime = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<DateTime>(
          stream: widget.cubit.birthDaySubject.stream,
          builder: (context, snapshot) {
            final data = snapshot.data ?? DateTime.now();
            return GestureDetector(
              onTap: () {
                isShowDateTime = !isShowDateTime;
                setState(() {});
              },
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: bgDropDown,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data.formatDdMMYYYY,
                  style: textNormal(selectColorTabbar, 14),
                ),
              ),
            );
          },
        ),
        if (isShowDateTime)
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              minimumYear: 1950,
              initialDateTime: DateTime(2001),
              maximumDate: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime value) {
                widget.cubit.birthDaySubject.add(value);
                widget.onChange(value);
              },
            ),
          )
        else
          Container(),
      ],
    );
  }
}
