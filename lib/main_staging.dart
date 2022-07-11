import 'package:ccvc_mobile/domain/env/model/app_constants.dart';
import 'package:ccvc_mobile/domain/env/staging.dart';
import 'package:ccvc_mobile/main.dart';
import 'package:get/get.dart';

Future<void> main() async {
  Get.put(AppConstants.fromJson(configStagEnvironment));
  await mainApp();
}
