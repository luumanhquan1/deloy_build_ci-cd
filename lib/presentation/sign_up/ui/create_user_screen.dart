import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/data/exception/app_exception.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:ccvc_mobile/presentation/home_screen/ui/home_screen.dart';
import 'package:ccvc_mobile/presentation/login/ui/login_screen.dart';
import 'package:ccvc_mobile/presentation/sign_up/bloc/sign_up_cubit.dart';
import 'package:ccvc_mobile/presentation/sign_up/ui/widget/avata_widget.dart';
import 'package:ccvc_mobile/presentation/sign_up/ui/widget/birth_day_widget.dart';
import 'package:ccvc_mobile/presentation/sign_up/ui/widget/container_data_widget.dart';
import 'package:ccvc_mobile/presentation/sign_up/ui/widget/drop_down_gender.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/utils/extensions/string_extension.dart';
import 'package:ccvc_mobile/widgets/appbar/base_app_bar.dart';
import 'package:ccvc_mobile/widgets/button/button_custom_bottom.dart';
import 'package:ccvc_mobile/widgets/textformfield/form_group.dart';
import 'package:ccvc_mobile/widgets/textformfield/text_field_validator.dart';
import 'package:ccvc_mobile/widgets/views/state_stream_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateUserScreen extends StatefulWidget {
  final SignUpCubit cubit;

  const CreateUserScreen({Key? key, required this.cubit}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final keyGroup = GlobalKey<FormGroupState>();
  TextEditingController textNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StateStreamLayout(
      stream: widget.cubit.stateStream,
      textEmpty: S.current.khong_co_du_lieu,
      retry: () {},
      error: AppException(S.current.khong_co_du_lieu, ''),
      child: Scaffold(
        appBar: BaseAppBar(
          title: S.current.tao_thong_tin_nguoi_dung,
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                    AvataWidget(
                      cubit: widget.cubit,
                    ),
                    spaceH16,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContainerDataWidget(
                          title: S.current.ho_ten,
                          child: TextFieldValidator(
                            controller: textNameController,
                            hintText: S.current.nguyen_van_a,
                            onChange: (text) {
                              if (text.isEmpty) {
                                setState(() {});
                                return widget.cubit.isHideClearData = false;
                              }
                              setState(() {});
                              return widget.cubit.isHideClearData = true;
                            },
                            validator: (value) {
                              return (value ?? '').checkNull();
                            },
                          ),
                        ),
                        ContainerDataWidget(
                          title: S.current.gioi_tinh,
                          child: DropDownGender(
                            items: const ['Nam', 'Nữ', 'Khác'],
                            onChange: (String value) {
                              widget.cubit.gender = value;
                            },
                          ),
                        ),
                        ContainerDataWidget(
                          title: S.current.ngay_sinh,
                          child: BirthDayWidget(
                            onChange: (value) {
                              widget.cubit.birthDay = value;
                            },
                            cubit: widget.cubit,
                          ),
                        ),
                      ],
                    ),
                    spaceH30,
                    ButtonCustomBottom(
                      title: S.current.dang_ky,
                      isColorBlue: true,
                      onPressed: () async {
                        if (keyGroup.currentState!.validator()) {
                          await widget.cubit.saveInformationUser(
                            textNameController.text,
                          );
                          _showToast(
                            context: context,
                            text: S.current.tao_tai_khoan_thanh_cong,
                          );
                          await widget.cubit.saveUser();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
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
