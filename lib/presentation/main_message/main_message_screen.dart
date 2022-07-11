import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';

import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:ccvc_mobile/presentation/main_message/bloc/main_message_cubit.dart';
import 'package:ccvc_mobile/presentation/main_message/widgets/loading_skeleton_message_widget.dart';
import 'package:ccvc_mobile/presentation/main_message/widgets/tin_nhan_cell.dart';
import 'package:ccvc_mobile/presentation/message/message_screen.dart';

import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/widgets/textformfield/base_search_bar.dart';
import 'package:ccvc_mobile/widgets/views/state_loading_skeleton.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMessageScreen extends StatefulWidget {
  const MainMessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MainMessageScreen> {
  MainMessageCubit cubit = MainMessageCubit();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.fetchRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: const Offset(0, 40),
            child: SvgPicture.asset(
              ImageAssets.icBackgroundMessage,
              fit: BoxFit.fill,
            ),
          ),
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  backgroundColor: Colors.transparent,
                  border: Border.all(color: Colors.transparent),
                  largeTitle: Text(
                    S.current.messages,
                    style: textNormalCustom(
                        color: colorBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  children: [
                    const BaseSearchBar(),
                    const SizedBox(
                      height: 30,
                    ),
                    StateLoadingSkeleton(
                      stream: cubit.stateStream,
                      skeleton: const LoadingSkeletonMessageWidget(),
                      child: StreamBuilder<List<RoomChatModel>>(
                          stream: cubit.getRoomChat,
                          builder: (context, snapshot) {
                            final data = snapshot.data ?? <RoomChatModel>[];
                            return Column(
                              children: List.generate(data.length, (index) {
                                final result = data[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MessageScreen(
                                            chatModel: result,
                                            peopleChat: result.getPeople(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: TinNhanCell(
                                      peopleChat: result.getPeople(), idRoom: result.roomId,
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
