import 'dart:typed_data';
import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_store.dart';
import 'package:ccvc_mobile/domain/locals/hive_local.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/presentation/sign_up/bloc/sign_up_cubit.dart';
import 'package:ccvc_mobile/presentation/update_user/bloc/update_user_state.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/utils/extensions/date_time_extension.dart';
import 'package:ccvc_mobile/utils/extensions/int_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class UpdateUserCubit extends BaseCubit<UpdateUserState> {
  UpdateUserCubit() : super(UpdateUserStateInitial());

  bool isHideClearData = false;
  bool isCheckEye1 = true;
  bool isCheckEyeXacNhan = true;
  bool isHideEyeXacNhan = false;
  bool isHideEye1 = false;
  bool passIsError = false;

  ///data user
  String nameDisplay = '';
  String gender = 'Nam';
  DateTime birthDay = DateTime(2001, 1, 1);
  Uint8List? image;
  UserModel userInfo = UserModel.empty();

  BehaviorSubject<DateTime> birthDaySubject =
      BehaviorSubject.seeded(DateTime(2001, 1, 1));

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return _file.readAsBytes();
    }
    return null;
  }

  Future<void> updateInfomationUser() async {
    showLoading();
    userInfo.nameDisplay = nameDisplay;
    userInfo.gender = gender.getGender;
    userInfo.birthday = birthDay.convertToTimesTamp;
    userInfo.createAt = DateTime.now().millisecondsSinceEpoch;
    userInfo.updateAt = DateTime.now().millisecondsSinceEpoch;

    if (image == null) {
      userInfo.avatarUrl = ImageAssets.imgEmptyAvata;
    } else {
      await FireStoreMethod.removeImage(userInfo.userId ?? '');
      await FireStoreMethod.uploadImageToStorage(
        userInfo.userId ?? '',
        image ?? Uint8List(0),
      );

      final String photoImage =
          await FireStoreMethod.downImage(userInfo.userId ?? '');
      userInfo.avatarUrl = photoImage;
    }
    await HiveLocal.updateDataUser(userInfo);
    await FireStoreMethod.updateUser(userInfo.userId ?? '', userInfo);
    showContent();
  }

  void initData() {
    showLoading();
    userInfo =  HiveLocal.getDataUser() ?? UserModel.empty();
    birthDaySubject.add(
      (userInfo.birthday ?? 0).convertToDateTime,
    );
    gender = toGender(userInfo.gender ?? true);
    showContent();
  }

  String toGender(bool gender) {
    if (gender) {
      return 'Nam';
    } else {
      return 'Nữ';
    }
  }
}
