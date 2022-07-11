import 'dart:typed_data';

import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_authentication.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_store.dart';
import 'package:ccvc_mobile/domain/locals/hive_local.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/presentation/sign_up/bloc/sign_up_state.dart';
import 'package:ccvc_mobile/utils/constants/dafault_env.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/utils/extensions/date_time_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class SignUpCubit extends BaseCubit<SignUpState> {
  SignUpCubit() : super(SignUpStateIntial());

  bool isHideClearData = false;
  bool isCheckEye1 = true;
  bool isCheckEyeXacNhan = true;
  bool isHideEyeXacNhan = false;
  bool isHideEye1 = false;
  bool passIsError = false;
  String gender = 'Nam';
  DateTime birthDay = DateTime(2001, 1, 1);
  UserModel dataUser = UserModel();
  Uint8List? image;

  BehaviorSubject<DateTime> birthDaySubject =
      BehaviorSubject.seeded(DateTime(2001, 1, 1));

  Future<void> saveUser() async {
    final snap = await FirebaseFirestore.instance
        .collection(DefaultEnv.socialNetwork)
        .doc(DefaultEnv.develop)
        .collection(DefaultEnv.users)
        .doc(PrefsService.getUserId())
        .collection(DefaultEnv.profile)
        .get();
    final UserModel userInfo = UserModel.fromJson(
      snap.docs.first.data(),
    );
    HiveLocal.saveDataUser(userInfo);
  }

  Future<User?> signUp(
    String email,
    String password,
  ) async {
    showLoading();
    final User? user = await FirebaseAuthentication.signUp(
      email: email,
      password: password,
    );

    if (user != null) {
      dataUser = UserModel(
        userId: user.uid,
        email: user.email,
        birthday: 0,
        gender: true,
        nameDisplay: user.displayName,
        createAt: 0,
        updateAt: 0,
      );

      await PrefsService.saveUserId(user.uid);
    }
    showContent();
    return user;
  }

  Future<void> saveInformationUser(
    String name,
  ) async {
    showLoading();
    dataUser.gender = gender.getGender;
    dataUser.birthday = birthDay.convertToTimesTamp;
    dataUser.nameDisplay = name;
    dataUser.createAt = DateTime.now().millisecondsSinceEpoch;
    dataUser.updateAt = DateTime.now().millisecondsSinceEpoch;

    if (image == null) {
      dataUser.avatarUrl = ImageAssets.imgEmptyAvata;
    } else {
      await FireStoreMethod.uploadImageToStorage(
        dataUser.userId ?? '',
        image ?? Uint8List(0),
      );

      final String photoImage =
          await FireStoreMethod.downImage(dataUser.userId ?? '');
      dataUser.avatarUrl = photoImage;
    }

    await FireStoreMethod.saveInformationUser(
      id: dataUser.userId ?? '',
      user: dataUser,
    );
    showContent();
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return _file.readAsBytes();
    }
    return null;
  }
}

extension ConvertGender on String {
  bool get getGender {
    switch (this) {
      case 'Nam':
        return true;
      case 'Nữ':
        return false;

      default:
        return true;
    }
  }
}
