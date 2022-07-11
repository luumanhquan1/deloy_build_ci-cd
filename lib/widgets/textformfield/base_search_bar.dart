import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseSearchBar extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChange;
  const BaseSearchBar({Key? key, this.hintText, this.controller, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 15,
          )
        ],
      ),
      child: TextFormField(
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        controller: controller,
        style: textNormal(titleCalenderWork, 15),
        decoration: InputDecoration(
          filled: true,
          hintText: hintText ?? S.current.search_for_contacts,
          hintStyle: textNormal(hintColor, 12),
          fillColor: backgroundColorApp,
          prefixIcon: SizedBox(
              width: 50,
              child: Center(child: SvgPicture.asset(ImageAssets.icSearch))),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }
}
