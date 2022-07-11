import 'package:ccvc_mobile/widgets/dialog/decorate_app.dart';
import 'package:ccvc_mobile/widgets/dialog/line_spin_fade_loader.dart';
import 'package:flutter/material.dart';

enum Indicator {
  ballPulse,
  ballGridPulse,
  ballClipRotate,
  squareSpin,
  ballClipRotatePulse,
  ballClipRotateMultiple,
  ballPulseRise,
  ballRotate,
  cubeTransition,
  ballZigZag,
  ballZigZagDeflect,
  ballTrianglePath,
  ballTrianglePathColored,
  ballTrianglePathColoredFilled,
  ballScale,
  lineScale,
  lineScaleParty,
  ballScaleMultiple,
  ballPulseSync,
  ballBeat,
  lineScalePulseOut,
  lineScalePulseOutRapid,
  ballScaleRipple,
  ballScaleRippleMultiple,
  ballSpinFadeLoader,
  lineSpinFadeLoader,
  triangleSkewSpin,
  pacman,
  ballGridBeat,
  semiCircleSpin,
  ballRotateChase,
  orbit,
  audioEqualizer,
  circleStrokeSpin,
}

class CupertinoLoading extends StatelessWidget {
  const CupertinoLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: DecorateContext(
        decorateData: DecorateData(
          indicator: Indicator.lineSpinFadeLoader,
          colors: getListColor(),
          strokeWidth: 4,
        ),
        child: const AspectRatio(
          aspectRatio: 1,
          child: LineSpinFadeLoader(),
        ),
      ),
    );
  }
}

List<Color> getListColor() {
  final colors = <Color>[
    const Color(0xff0DBFBA),
    const Color(0xff1BCEB8),
    const Color(0xff26DBC0),
    const Color(0xff2EE5C6),
    const Color(0xff3BEDCB),
    const Color(0xff57F7D8),
    const Color(0xff76FFE5),
    const Color(0xffBBFFF2),
    const Color(0xffE1FFF9),
    const Color(0xffF3FFFD),
    const Color(0xff11AEBA),
    const Color(0xff0FB8BC),
  ];
  return colors;
}
