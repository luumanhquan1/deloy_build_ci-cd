import 'package:ccvc_mobile/config/firebase_config.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum BaseURLOption { GATE_WAY, COMMON, CCVC, API_AND_UAT }

void configureDependencies() {

  //login
  // Get.put(AccountService(provideDio(baseOption: BaseURLOption.COMMON)));
  // Get.put(
  //     AccountServiceGateWay(provideDio(baseOption: BaseURLOption.GATE_WAY)));
  // Get.put<AccountRepository>(
  //   AccountImpl(Get.find(), Get.find()),
  // );

  // lich lam viec

  
}

int _connectTimeOut = 60000;

CollectionReference provideFireBase({required String nameCollection}) {
  return FirebaseSetup.fireStore.collection(nameCollection);
}

PrettyDioLogger dioLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    maxWidth: 100,
  );
}
