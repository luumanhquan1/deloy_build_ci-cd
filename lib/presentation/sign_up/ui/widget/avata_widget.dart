import 'dart:typed_data';

import 'package:ccvc_mobile/presentation/sign_up/bloc/sign_up_cubit.dart';
import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvataWidget extends StatefulWidget {
  final SignUpCubit cubit;

  const AvataWidget({Key? key, required this.cubit}) : super(key: key);

  @override
  State<AvataWidget> createState() => _AvataWidgetState();
}

class _AvataWidgetState extends State<AvataWidget> {
  Uint8List? _image;

  Future<void> selectImage() async {
    final Uint8List? im = await widget.cubit.pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
      widget.cubit.image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
     // overflow: Overflow.visible,
      children: [
        if (_image == null)
          const CircleAvatar(
            radius: 64, // Image radius
            backgroundImage: NetworkImage(ImageAssets.imgEmptyAvata),
          )
        else
          CircleAvatar(
            radius: 64, // Image radius
            backgroundImage: MemoryImage(_image ?? Uint8List(0)),
          ),
        Positioned(
          bottom: -5,
          left: 90,
          child: GestureDetector(
            onTap: selectImage,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey,),
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}