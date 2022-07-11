import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/data/exception/app_exception.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_authentication.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_const.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:ccvc_mobile/presentation/login/bloc/login_cubit.dart';
import 'package:ccvc_mobile/presentation/sign_up/ui/sign_up_screen.dart';
import 'package:ccvc_mobile/presentation/tabbar_screen/ui/main_screen.dart';
import 'package:ccvc_mobile/utils/constants/app_constants.dart';
import 'package:ccvc_mobile/utils/constants/dafault_env.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/utils/extensions/string_extension.dart';
import 'package:ccvc_mobile/widgets/button/button_custom_bottom.dart';
import 'package:ccvc_mobile/widgets/textformfield/form_group.dart';
import 'package:ccvc_mobile/widgets/textformfield/text_field_validator.dart';
import 'package:ccvc_mobile/widgets/views/state_stream_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginCubit loginCubit = LoginCubit();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  final keyGroup = GlobalKey<FormGroupState>();

  @override
  void initState() {
    super.initState();
    loginCubit.closeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return StateStreamLayout(
      textEmpty: S.current.khong_co_du_lieu,
      retry: () {},
      error: AppException('', S.current.something_went_wrong),
      stream: loginCubit.stateStream,
      child: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                  const EdgeInsets.only(top: 60, left: 16.0, right: 16.0),
                  child: FormGroup(
                    key: keyGroup,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 250,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                ImageAssets.imgLoginPng,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                '${S.current.hello}!',
                                style: titleAppbar(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                S.current.wellcom_login,
                                style: textNormal(AqiColor, 14),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFieldValidator(
                                controller: fullNameController,
                                suffixIcon: loginCubit.isHideClearData
                                    ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                        fullNameController.clear();
                                        loginCubit.isHideClearData =
                                        false;
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
                                    child:
                                    SvgPicture.asset(ImageAssets.imgAcount),
                                  ),
                                ),
                                onChange: (text) {
                                  if (text.isEmpty) {
                                    setState(() {});
                                    return loginCubit.isHideClearData = false;
                                  }
                                  setState(() {});
                                  return loginCubit.isHideClearData = true;
                                },
                                validator: (value) {
                                  return (value ?? '').checkNull();
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFieldValidator(
                                controller: textPasswordController,
                                obscureText: loginCubit.isCheckEye1,
                                suffixIcon: loginCubit.isHideEye1
                                    ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                        loginCubit.isCheckEye1 =
                                        !loginCubit.isCheckEye1;
                                      },
                                      child: loginCubit.isCheckEye1
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
                                    return loginCubit.isHideEye1 = false;
                                  }
                                  setState(() {});
                                  return loginCubit.isHideEye1 = true;
                                },
                                validator: (value) {
                                  return (value ?? '').checkNull();
                                },
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              ButtonCustomBottom(
                                title: S.current.login,
                                isColorBlue: true,
                                onPressed: () async {
                                  if (keyGroup.currentState!.validator()) {
                                    final User? user = await loginCubit.lognIn(
                                      fullNameController.text.trim(),
                                      textPasswordController.text.trim(),
                                    );
                                    if (user != null) {
                                      await Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const MainTabBarView(),
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
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        S.current.dang_ky,
                                        style: textNormalCustom(
                                          color: textDefault,

                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 30,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
