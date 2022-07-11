import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

const HERO_TAG_CAMERA = 'CAMERA_TAG';

class CameraPhotoWidget extends StatefulWidget {
  final Function(XFile) onChange;
  const CameraPhotoWidget({Key? key,required this.onChange}) : super(key: key);

  @override
  _CameraPhotoWidgetState createState() => _CameraPhotoWidgetState();
}

class _CameraPhotoWidgetState extends State<CameraPhotoWidget> {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  ValueNotifier<bool> isInitCamera = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() async {
    _cameras = await availableCameras();
    final firstCam = _cameras.first;

    controller = CameraController(
      firstCam,
      ResolutionPreset.high,
    );
    await controller?.initialize();
    isInitCamera.value = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 700),
              pageBuilder: (_, __, ___) => CameraPhotoScreen(
                camera: _cameras,
              ),
            ),
          ).then((value) {
            if(value!=null){
           widget.onChange(value);

            }
            onNewCameraSelected(_cameras[0]);

          });
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: isInitCamera,
          builder: (context, value, _) {
            if (value && controller != null) {
              return CameraPreview(controller!);
            } else {
              return Container(
                color: Colors.black,
              );
            }
          },
        ));
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    CameraController? oldController = controller;
    if (oldController != null) {
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    controller = cameraController;
    await cameraController.initialize();

    if (mounted) {
      setState(() {});
    }
  }
}

class CameraPhotoScreen extends StatefulWidget {
  final List<CameraDescription> camera;
  const CameraPhotoScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraPhotoScreenState createState() => _CameraPhotoScreenState();
}

class _CameraPhotoScreenState extends State<CameraPhotoScreen> {
  CameraController? controller;
  FlashMode flashMode = FlashMode.off;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onNewCameraSelected(widget.camera[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.centerLeft,
            child: controller?.description == widget.camera[0]
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                        onTap: () {
                          if (flashMode == FlashMode.off) {
                            flashMode = FlashMode.always;
                          } else {
                            flashMode = FlashMode.off;
                          }
                          controller?.setFlashMode(flashMode);
                          setState(() {});
                        },
                        child: Icon(
                          flashMode == FlashMode.off
                              ? Icons.flash_off
                              : Icons.flash_on,
                          color: Colors.white,
                        )),
                  )
                : const SizedBox(),
          ),
          Expanded(
              child: SizedBox(
                  width: double.infinity, child: CameraPreview(controller!))),
          SafeArea(
            child: Container(
              height: 120,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonFeature(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                  takePhotoWidget(onTap: () async {
                    final file = await controller?.takePicture();
                    log('${file?.path}');
                    Navigator.pop(context,file);

                  }),
                  buttonFeature(
                      onTap: () {
                        if (controller == null) {
                          return;
                        }
                        if (controller!.description == widget.camera[0]) {
                          onNewCameraSelected(widget.camera[1]);
                        } else {
                          onNewCameraSelected(widget.camera[0]);
                        }
                      },
                      icon: Icon(
                        Icons.cached,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonFeature({required Function() onTap, required Widget icon}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    CameraController? oldController = controller;
    if (oldController != null) {
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    controller = cameraController;
    await cameraController.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  Widget takePhotoWidget({required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 130,
        width: 130,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4)),
        child: Container(
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
