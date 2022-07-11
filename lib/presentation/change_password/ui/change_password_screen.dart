import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/data/exception/app_exception.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:ccvc_mobile/presentation/change_password/bloc/change_password_cubit.dart';
import 'package:ccvc_mobile/presentation/home_screen/ui/home_screen.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/utils/extensions/string_extension.dart';
import 'package:ccvc_mobile/widgets/appbar/base_app_bar.dart';
import 'package:ccvc_mobile/widgets/button/button_custom_bottom.dart';
import 'package:ccvc_mobile/widgets/textformfield/form_group.dart';
import 'package:ccvc_mobile/widgets/textformfield/text_field_validator.dart';
import 'package:ccvc_mobile/widgets/views/state_stream_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordCubit cubit = ChangePasswordCubit();
  final keyGroup = GlobalKey<FormGroupState>();
  TextEditingController textMatKhauCuController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  TextEditingController xacNhanMatKhauController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.showContent();
  }

  @override
  Widget build(BuildContext context) {
    return StateStreamLayout(
      textEmpty: S.current.khong_co_du_lieu,
      retry: () {},
      error: AppException('', S.current.something_went_wrong),
      stream: cubit.stateStream,
      child: Scaffold(
        appBar: BaseAppBar(
          title: S.current.doi_mat_khau,
          leadingIcon: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              height: 10,
              width: 10,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: AqiColor,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FormGroup(
            key: keyGroup,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  spaceH30,
                  Image.asset(ImageAssets.imgChangePassword),
                  spaceH30,
                  TextFieldValidator(
                    controller: textMatKhauCuController,
                    obscureText: cubit.isCheckEye2,
                    suffixIcon: cubit.isHideEye2
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  cubit.isCheckEye2 = !cubit.isCheckEye2;
                                },
                                child: cubit.isCheckEye2
                                    ? SvgPicture.asset(
                                        ImageAssets.imgView,
                                      )
                                    : SvgPicture.asset(
                                        ImageAssets.imgViewHide,
                                      ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    hintText: S.current.mat_khau_hien_tai,
                    prefixIcon: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Center(
                        child: SvgPicture.asset(ImageAssets.icConfirm),
                      ),
                    ),
                    onChange: (text) {
                      if (text.isEmpty) {
                        setState(() {});
                        return cubit.isHideEye2 = false;
                      }
                      setState(() {});
                      return cubit.isHideEye2 = true;
                    },
                    validator: (value) {
                      return (value ?? '').checkNull();
                    },
                  ),
                  spaceH16,
                  TextFieldValidator(
                    controller: textPasswordController,
                    obscureText: cubit.isCheckEye1,
                    suffixIcon: cubit.isHideEye1
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  cubit.isCheckEye1 = !cubit.isCheckEye1;
                                },
                                child: cubit.isCheckEye1
                                    ? SvgPicture.asset(
                                        ImageAssets.imgView,
                                      )
                                    : SvgPicture.asset(
                                        ImageAssets.imgViewHide,
                                      ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    hintText: S.current.mat_khau_moi,
                    prefixIcon: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Center(
                        child: SvgPicture.asset(
                          ImageAssets.imgPassword,
                        ),
                      ),
                    ),
                    onChange: (text) {
                      if (text.isEmpty) {
                        setState(() {});
                        return cubit.isHideEye1 = false;
                      }
                      setState(() {});
                      return cubit.isHideEye1 = true;
                    },
                    validator: (value) {
                      return (value ?? '').checkNull();
                    },
                  ),
                  spaceH16,
                  TextFieldValidator(
                    controller: xacNhanMatKhauController,
                    obscureText: cubit.isCheckEyeXacNhan,
                    suffixIcon: cubit.isHideEyeXacNhan
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  cubit.isCheckEyeXacNhan =
                                      !cubit.isCheckEyeXacNhan;
                                },
                                child: cubit.isCheckEyeXacNhan
                                    ? SvgPicture.asset(
                                        ImageAssets.imgView,
                                      )
                                    : SvgPicture.asset(
                                        ImageAssets.imgViewHide,
                                      ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    hintText: S.current.xac_nhan_mat_khau_moi,
                    prefixIcon: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Center(
                        child: SvgPicture.asset(
                          ImageAssets.imgPassword,
                        ),
                      ),
                    ),
                    onChange: (text) {
                      if (text.isEmpty) {
                        setState(() {});
                        return cubit.isHideEyeXacNhan = false;
                      }
                      setState(() {});
                      return cubit.isHideEyeXacNhan = true;
                    },
                    validator: (value) {
                      return (value ?? '')
                          .xacNhanMatKhau(textPasswordController.text);
                    },
                  ),
                  spaceH30,
                  ButtonCustomBottom(
                    title: S.current.cap_nhat,
                    isColorBlue: true,
                    onPressed: () async {
                      if (keyGroup.currentState!.validator()) {
                        if (!cubit
                            .isMatchPassword(textMatKhauCuController.text)) {
                          _showToast(
                            context: context,
                            text: S.current.mat_khau_hien_tai_chua_chinh_xac,
                          );
                        } else {
                          await cubit.changePassword(
                            newPassword: xacNhanMatKhauController.text,
                            subsess: () {
                              _showToast(
                                context: context,
                                text: S.current.doi_mat_khau_thanh_cong,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(),
                                ),
                              );
                            },
                            error: (String error) {
                              _showToast(
                                context: context,
                                text: error,
                              );
                            },
                          );
                        }
                      } else {
                        _showToast(
                          context: context,
                        );
                      }
                    },
                  ),
                  spaceH30,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showToast({required BuildContext context, String? text}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text ?? S.current.dang_nhap_that_bai),
      ),
    );
  }
}
