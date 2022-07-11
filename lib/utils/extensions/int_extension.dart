extension IntExtension on int {
  DateTime get convertToDateTime => DateTime.fromMicrosecondsSinceEpoch(this);
}
