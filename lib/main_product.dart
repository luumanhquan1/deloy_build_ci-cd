import 'package:ccvc_mobile/domain/env/model/app_constants.dart';
import 'package:ccvc_mobile/domain/env/product.dart';
import 'package:ccvc_mobile/main.dart';
import 'package:get/get.dart';

Future<void> main() async {
  Get.put(AppConstants.fromJson(configProductEnv));
  await mainApp();
}
