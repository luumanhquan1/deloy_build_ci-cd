import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/data/exception/app_exception.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:ccvc_mobile/presentation/sign_up/bloc/sign_up_cubit.dart';
import 'package:ccvc_mobile/presentation/sign_up/ui/create_user_screen.dart';
import 'package:ccvc_mobile/utils/constants/app_constants.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/utils/extensions/string_extension.dart';
import 'package:ccvc_mobile/widgets/appbar/base_app_bar.dart';
import 'package:ccvc_mobile/widgets/button/button_custom_bottom.dart';
import 'package:ccvc_mobile/widgets/textformfield/form_group.dart';
import 'package:ccvc_mobile/widgets/textformfield/text_field_validator.dart';
import 'package:ccvc_mobile/widgets/views/state_stream_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpCubit cubit = SignUpCubit();

  final keyGroup = GlobalKey<FormGroupState>();
  TextEditingController textTaiKhoanController = TextEditingController();
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
          title: S.current.dang_ky,
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
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          ImageAssets.icBackgroundMessage,
                          fit: BoxFit.fill,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.current.welcome_to,
                                style: GoogleFonts.poppins(
                                  color: welCome,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                S.current.socially,
                                style: GoogleFonts.poppins(
                                  color: welCome,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceH30,
                  TextFieldValidator(
                    controller: textTaiKhoanController,
                    suffixIcon: cubit.isHideClearData
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  textTaiKhoanController.clear();
                                  cubit.isHideClearData = false;
                                },
                                child: SvgPicture.asset(
                                  ImageAssets.icClearLogin,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    hintText: S.current.account,
                    prefixIcon: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Center(
                        child: SvgPicture.asset(ImageAssets.imgAcount),
                      ),
                    ),
                    onChange: (text) {
                      if (text.isEmpty) {
                        setState(() {});
                        return cubit.isHideClearData = false;
                      }
                      setState(() {});
                      return cubit.isHideClearData = true;
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
                    hintText: S.current.password,
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
                    hintText: S.current.xac_nhan_mat_khau,
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
                    title: S.current.dang_ky,
                    isColorBlue: true,
                    onPressed: () async {
                      if (keyGroup.currentState!.validator()) {
                        final User? user = await cubit.signUp(
                          textTaiKhoanController.text.trim(),
                          textPasswordController.text.trim(),
                        );

                        if (user != null) {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CreateUserScreen(
                                cubit: cubit,
                              ),
                            ),
                          );
                        } else {
                          _showToast(
                            context: context,
                            text: EXCEPTION_LOGIN,
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
