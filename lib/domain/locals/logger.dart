import 'package:flutter/foundation.dart' as Foundation;
import 'package:logger/logger.dart';

final logger = Logger(
  printer: Foundation.kDebugMode ? PrettyPrinter() : null, // Use the default Lo
  // gOutput (-> send everything to console)
);
