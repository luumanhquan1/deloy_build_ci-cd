import 'package:ccvc_mobile/presentation/update_user/bloc/update_user_cubit.dart';
import 'package:ccvc_mobile/utils/extensions/date_time_extension.dart';
import 'package:ccvc_mobile/utils/extensions/int_extension.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config/resources/color.dart';
import '../../../../config/resources/styles.dart';

class BirthDayUpdateWidget extends StatefulWidget {
  final UpdateUserCubit cubit;
  final Function(DateTime value) onChange;

  const BirthDayUpdateWidget({
    Key? key,
    required this.cubit,
    required this.onChange,
  }) : super(key: key);

  @override
  State<BirthDayUpdateWidget> createState() => _BirthDayUpdateWidgetState();
}

class _BirthDayUpdateWidgetState extends State<BirthDayUpdateWidget> {
  bool isShowDateTime = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<DateTime>(
          initialData: (widget.cubit.userInfo.birthday ?? 0).convertToDateTime,
          stream: widget.cubit.birthDaySubject.stream,
          builder: (context, snapshot) {
            final data = snapshot.data ??
                (widget.cubit.userInfo.birthday ?? 0).convertToDateTime;
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
              initialDateTime:
                  (widget.cubit.userInfo.birthday ?? 0).convertToDateTime,
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
