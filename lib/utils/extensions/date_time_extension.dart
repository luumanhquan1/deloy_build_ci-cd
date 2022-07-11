import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:intl/intl.dart';


enum TimeRange { HOM_NAY, TUAN_NAY, THANG_NAY, NAM_NAY }

extension DateFormatString on DateTime {
  String get toStringWithAMPM {
    final dateString = DateFormat.jm('en').format(this);
    return dateString;
  }
  String get formatDdMMYYYY {
    final dateString =
        DateFormat('dd/MM/yyyy ').format(this);
    return dateString;
  }
  int get convertToTimesTamp {
    return microsecondsSinceEpoch;
  }
}
