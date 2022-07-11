import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/images.dart';
import 'package:ccvc_mobile/config/resources/strings.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/config/themes/theme_color.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_authentication.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/presentation/home_screen/bloc/home_cubit.dart';
import 'package:ccvc_mobile/presentation/home_screen/bloc/home_state.dart';
import 'package:ccvc_mobile/presentation/login/ui/login_screen.dart';
import 'package:ccvc_mobile/presentation/post/ui/post_screen.dart';
import 'package:ccvc_mobile/presentation/profile/ui/profile_screen.dart';
import 'package:ccvc_mobile/utils/app_utils.dart';
import 'package:ccvc_mobile/widgets/app_image.dart';
import 'package:ccvc_mobile/widgets/post_item/post_item.dart';
import 'package:ccvc_mobile/widgets/post_item/post_item_skeleton.dart';
import 'package:ccvc_mobile/widgets/refresh_widget.dart';
import 'package:ccvc_mobile/widgets/views/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/locals/hive_local.dart';
import '../../../domain/locals/prefs_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    //  required this.userId
  }) : super(key: key);
  //String userId;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  HomeCubit _homeCubit = HomeCubit();
  @override
  void initState() {
    super.initState();
    final data = HiveLocal.getDataUser();
    print('${data?.userId} ?????????');
    // _homeCubit.getUserInfo(widget.userId);
    // _homeCubit.getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateLayout>(
      stream: _homeCubit.stateStream,
      builder: (context, snapshot) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            //backgroundColor: Color(0xFF339999),
            elevation: 0,
            automaticallyImplyLeading: false,
            title:       Text(Strings.app_name,
                style:  heading2(color: ThemeColor.black)),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 24.sp),
                //   child: Container(
                //     color: colorPrimary,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       children: [
                //         Text(Strings.app_name,
                //             style: titleAppbar(color: ThemeColor.black)),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 27.sp,
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 24.sp),
                //   child: Text(Strings.feed,
                //       style: heading2(color: ThemeColor.black)),
                // ),
                // SizedBox(
                //   height: 27.sp,
                // ),
                // StreamBuilder(
                //   stream: _homeCubit.posts,
                //   builder: (context, snapshot) =>
                Expanded(
                    child: RefreshWidget(
                      // enableLoadMore: controller.canLoadMore.value,
                      //  onLoadMore: () async {
                      //    double oldPosition =
                      //        controller.scrollController.position.pixels;
                      //    await controller.getWeights();
                      //    controller.scrollController.position.jumpTo(oldPosition);
                      //  },
                        controller: refreshController,
                        onRefresh: () async {
                          await _homeCubit.getAllPosts();
                          refreshController.refreshCompleted();
                        },
                        child: snapshot.data == null
                            ? SizedBox()
                            : _buildBody(snapshot.data!)
                      // CustomScrollView(
                      //   //   controller: controller.scrollController,
                      //     slivers: [
                      //       SliverList(
                      //           delegate: SliverChildListDelegate(
                      //             [
                      //               Column(
                      //                   crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //                   children:
                      //                   //[
                      //                   (snapshot.data! as List)
                      //                       .map((e) =>
                      //                       PostCard(postModel: e, userId: 'gCpoUW47luwn7wGX3AgY',deletePost: (){},))
                      //                       .toList()
                      //                 // controller.rxLoadedList.value ==
                      //                 //     LoadedType.start
                      //                 //     ? historyListSkeleton
                      //                 //     : controller.weightsList.value
                      //                 //     .map((e) => _buildWeightListTile(e))
                      //                 //     .toList()),
                      //                 //    ]
                      //               )
                      //             ],
                      //           ))
                      //     ]),
                    )),
                //  )
              ]),

          //   )),
        ),
      ),
    );
  }

  Widget _buildBody(StateLayout state) {
    //HomeCubit _homeCubit = HomeCubit(widget.userId);
    if (state == StateLayout.showLoading) {
      return CustomScrollView(
        //   controller: controller.scrollController,
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.gray77,
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeColor.white),
                          child: PostItemSkeleton()),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.gray77,
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeColor.white),
                          child: PostItemSkeleton()),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.gray77,
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeColor.white),
                          child: PostItemSkeleton()),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.gray77,
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeColor.white),
                          child: PostItemSkeleton()),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.gray77,
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeColor.white),
                          child: PostItemSkeleton()),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.gray77,
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeColor.white),
                          child: PostItemSkeleton()),
                    ])
                  ],
                ))
          ]);
    }
    if (state == StateLayout.showContent) {
      return StreamBuilder(
          stream: _homeCubit.user,
          builder: (context, user) => SingleChildScrollView(
            child: StreamBuilder(
                stream: _homeCubit.posts,
                builder: (context, snapshot) => snapshot.data == null
                    ? SizedBox()
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    //[

                    (snapshot.data! as List)
                        .map((e) => Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 16.sp,
                          horizontal: 24.sp),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ThemeColor.gray77,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0,
                                  3), // changes position of shadow
                            ),
                          ],
                          borderRadius:
                          BorderRadius.circular(20),
                          color: ThemeColor.white),
                      child: PostCard(
                        postModel: e,
                        userId:
                        (user.data as UserModel).userId ??
                            '',
                        onTapName: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userId: (e as PostModel).author?.userId ??
                            ''))),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PostScreen(
                                  postId: e.postId,
                                ))),
                      ),
                    ))
                        .toList())),
          ));
    }
    if (state == StateLayout.showError) {
      return Center(
        child: Text('Đã xảy ra lỗi. Vui lòng thử lại sau'),
      );
    }

    return SizedBox();
  }

// Widget _buildPostItem({
//   required PostModel postModel,
// }) {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 24.sp),
//     child: Container(
//       // height: 200,
//       // width: 200,
//       //margin: EdgeInsets.symmetric(vertical: 8.sp),
//       decoration: BoxDecoration(boxShadow: [
//         BoxShadow(
//           color: ThemeColor.gray77,
//           spreadRadius: 0,
//           blurRadius: 5,
//           offset: Offset(0, 3), // changes position of shadow
//         ),
//       ], borderRadius: BorderRadius.circular(20), color: ThemeColor.white),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 16.sp, top: 16.sp),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: 40.sp,
//                     width: 40.sp,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: ThemeColor.paleGrey,
//                     ),
//                     child: postModel.author?.avatarUrl == null ||
//                             postModel.author!.avatarUrl!.isEmpty
//                         ? SizedBox()
//                         : AppImage.network(
//                             path: postModel.author!.avatarUrl!,
//                             //'https://img.freepik.com/free-vector/vector-set-two-different-dog-breeds-dog-illustration-flat-style_619130-447.jpg?w=1480',
//                             fit: BoxFit.fill,
//                             height: 40.sp,
//                             width: 40.sp,
//                           ),
//                   ),
//                 ),
//                 // SizedBox(width: 12.sp,),
//                 Expanded(
//                   flex: 7,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         postModel.author?.nameDisplay ?? '',
//                         //      'abcs',
//                         style: username(),
//                       ),
//                       SizedBox(
//                         height: 3.sp,
//                       ),
//                       Text(
//                         parseTimeCreate(int.parse(postModel.createAt ?? '0')),
//                         //'2 hrs ago',
//                         style:
//                             detail(color: ThemeColor.black.withOpacity(0.7)),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                     flex: 1,
//                     child: IconButton(
//                       onPressed: () {},
//                       icon: AppImage.asset(
//                         path: icOption,
//                         width: 18.sp,
//                         height: 18.sp,
//                         color: ThemeColor.grey,
//                       ),
//                     ))
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 35.sp),
//             child: Text(
//               postModel.content ?? '',
//               //      'abcs',
//               style: caption(color: ThemeColor.black),
//             ),
//           ),
//           // SizedBox(
//           //   height: 12.sp,
//           // ),
//           postModel.type != null && postModel.type == 1
//               ? SizedBox()
//               : Center(
//                   child: Padding(
//                     padding:  EdgeInsets.only(top:12.sp),
//                     child: AppImage.network(
//                       path:
//                           //     'https://img.freepik.com/free-vector/vector-set-two-different-dog-breeds-dog-illustration-flat-style_619130-447.jpg?w=1480'
//                           postModel.imageUrl!,
//                       height: 200,
//                       width: 200,
//                       fit: BoxFit.scaleDown,
//                     ),
//                   ),
//                 ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Expanded(
//                     child: Padding(
//                   padding: EdgeInsets.only(right: 8.sp),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(35),
//                         color: ThemeColor.paleGrey),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 10.sp, vertical: 6.sp),
//                       child: Row(
//                         children: [
//                           AppImage.asset(
//                             path: icHeart,
//                             color: ThemeColor.grey,
//                             width: 20.sp,
//                             height: 20.sp,
//                           ),
//                           SizedBox(
//                             width: 11.sp,
//                           ),
//                           Text(
//                             postModel.likes != null && postModel.likes! > 1000
//                                 ? '${postModel.likes! / 1000}K'
//                                 : '${postModel.likes}',
//                             style: textNormal(ThemeColor.grey, 12.sp),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 )),
//                 Expanded(
//                     child: Padding(
//                   padding: EdgeInsets.only(right: 8.sp),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(35),
//                         color: ThemeColor.paleGrey),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 10.sp, vertical: 6.sp),
//                       child: Row(
//                         children: [
//                           AppImage.asset(
//                             path: icMessage,
//                             color: ThemeColor.grey,
//                             width: 20.sp,
//                             height: 20.sp,
//                           ),
//                           SizedBox(
//                             width: 5.sp,
//                           ),
//                           Text(
//                             postModel.comments != null &&
//                                     postModel.comments! > 1000
//                                 ? '${postModel.comments! / 1000}K'
//                                 : '${postModel.comments}',
//                             style: textNormal(ThemeColor.grey, 12.sp),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ))
//               ],
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
}
