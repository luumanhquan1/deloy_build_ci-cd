import 'dart:developer';

import 'package:ccvc_mobile/config/resources/images.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/config/themes/theme_color.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/repository/post_repository.dart';
import 'package:ccvc_mobile/utils/app_utils.dart';
import 'package:ccvc_mobile/widgets/app_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final PostModel postModel;
  final String userId;
  final Function()? onTap;
  final Function()? onTapName;
  const PostCard(
      {Key? key, required this.postModel, this.userId = '', this.onTap, this.onTapName})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
  }

  void onLike() {
    //  widget.likePost;
    setState(() {
      isLikeAnimating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
       log('vvvvvvvvvvvvvv' + widget.userId);
    return GestureDetector(
      onTap: widget.onTap,
//      onDoubleTap: onLike,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.sp, top: 16.sp, bottom: 12.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: widget.onTapName,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          color: ThemeColor.paleGrey,
                        ),
                        child: widget.postModel.author?.avatarUrl == null ||
                                widget.postModel.author!.avatarUrl!.isEmpty
                            ? SizedBox()
                            : AppImage.network(
                                path: widget.postModel.author!.avatarUrl!,
                                //'https://img.freepik.com/free-vector/vector-set-two-different-dog-breeds-dog-illustration-flat-style_619130-447.jpg?w=1480',

                                height: 40.sp,
                                width: 40.sp,
                              ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 12.sp,),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: widget.onTapName,
                          child: Text(
                            widget.postModel.author?.nameDisplay ?? '',
                            //      'abcs',
                            style: username(),
                          ),
                        ),
                        SizedBox(
                          height: 3.sp,
                        ),
                        Text(
                          parseTimeCreate(widget.postModel.createAt ?? 0),
                          //'2 hrs ago',
                          style:
                              detail(color: ThemeColor.black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: widget.postModel.author!.userId! == widget.userId
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: ListView(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.sp),
                                          shrinkWrap: true,
                                          children: [
                                            'Xóa bài viết',
                                          ]
                                              .map(
                                                (e) => InkWell(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                    onTap: () async {
                                                      final result =
                                                          await showOkCancelAlertDialog(
                                                        context: context,
                                                        title: 'Xóa bài viết',
                                                        message:
                                                            'Bạn có muốn xóa bài viết này?',
                                                        okLabel: 'Xóa',
                                                        cancelLabel: 'Hủy',
                                                        fullyCapitalizedForMaterial:
                                                            false,
                                                      );
                                                      log(result.name
                                                          .toString());
                                                      // remove the dialog box
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (widget.onTap ==
                                                          null) {
                                                        log('message');
                                                          Navigator.of(context)
                                                              .pop();
                                                        // Navigator.of(context)
                                                        //     .pop();
                                                      }
                                                      if (result.name == 'ok') {
                                                        await PostRepository()
                                                            .deletePost(widget
                                                                    .postModel
                                                                    .postId ??
                                                                '');

                                                      }
                                                    }),
                                              )
                                              .toList()),
                                    );
                                  });
                            },
                            icon: AppImage.asset(
                              path: icOption,
                              width: 18.sp,
                              height: 18.sp,
                              color: ThemeColor.grey,
                            ),
                          )
                        : SizedBox())
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              widget.postModel.content ?? '',
              //      'abcs',
              style: caption(color: ThemeColor.black),
            ),
          ),
          // SizedBox(
          //   height: 12.sp,
          // ),
          widget.postModel.type != null && widget.postModel.type == 1
              ? SizedBox()
              : Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 12.sp,
                          left: 16.sp,
                          right: 16.sp,
                        ),
                        child: AppImage.network(
                          path:
                              //     'https://img.freepik.com/free-vector/vector-set-two-different-dog-breeds-dog-illustration-flat-style_619130-447.jpg?w=1480'
                              widget.postModel.imageUrl!,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    // AnimatedOpacity(
                    //        duration: const Duration(milliseconds: 200),
                    //        opacity: isLikeAnimating ? 1 : 0,
                    //        child: Center(
                    //          child: LikeAnimation(
                    //            isAnimating: isLikeAnimating,
                    //            child: const Icon(
                    //              Icons.favorite,
                    //              color: Colors.red,
                    //              size: 100,
                    //            ),
                    //            duration: const Duration(
                    //              milliseconds: 400,
                    //            ),
                    //            onEnd: () {
                    //              setState(() {
                    //                isLikeAnimating = false;
                    //              });
                    //            },
                    //          ),
                    //
                    //      ),
                    //    ),
                  ],
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(right: 8.sp),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: ThemeColor.paleGrey),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 6.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // AppImage.asset(
                          //   path: icHeart,
                          //   color: ThemeColor.grey,
                          //   width: 20.sp,
                          //   height: 20.sp,
                          // ),
                          LikeAnimation(
                              isAnimating: widget.postModel.likes!
                                  .contains(widget.userId),
                              smallLike: true,
                              child: GestureDetector(
                                child: widget.postModel.likes!
                                        .contains(widget.userId)
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 20.sp,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 20.sp,
                                      ),
                                onTap: () => PostRepository().likePost(
                                  widget.postModel.postId!,
                                  widget.userId,
                                  widget.postModel.likes!,
                                ),
                              )),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Text(
                            widget.postModel.likes != null &&
                                    widget.postModel.likes!.length > 1000
                                ? '${widget.postModel.likes!.length / 1000}K'
                                : '${widget.postModel.likes!.length}',
                            style: textNormal(ThemeColor.grey, 12.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(right: 8.sp),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: ThemeColor.paleGrey),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 6.sp),
                      child: Row(
                        children: [
                          // AppImage.asset(
                          //   path: icMessage,
                          //   color: ThemeColor.grey,
                          //   width: 20.sp,
                          //   height: 20.sp,
                          // ),
                          Icon(
                            Icons.messenger_outline,
                            size: 20.sp,
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Text(
                            widget.postModel.comments != null &&
                                    widget.postModel.comments!.length > 1000
                                ? '${widget.postModel.comments!.length / 1000}K'
                                : '${widget.postModel.comments!.length}',
                            style: textNormal(ThemeColor.grey, 12.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
  // return Container(
  //   // boundary needed for web
  //   decoration: BoxDecoration(
  //     border: Border.all(
  //       color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
  //     ),
  //     color: mobileBackgroundColor,
  //   ),
  //   padding: const EdgeInsets.symmetric(
  //     vertical: 10,
  //   ),
  //   child: Column(
  //     children: [
  //       // HEADER SECTION OF THE POST
  //       Container(
  //         padding: const EdgeInsets.symmetric(
  //           vertical: 4,
  //           horizontal: 16,
  //         ).copyWith(right: 0),
  //         child: Row(
  //           children: <Widget>[
  //             CircleAvatar(
  //               radius: 16,
  //               backgroundImage: NetworkImage(
  //                 widget.snap['profImage'].toString(),
  //               ),
  //             ),
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(
  //                   left: 8,
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Text(
  //                       widget.snap['username'].toString(),
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             widget.snap['uid'].toString() == user.uid
  //                 ? IconButton(
  //               onPressed: () {
  //                 showDialog(
  //                   useRootNavigator: false,
  //                   context: context,
  //                   builder: (context) {
  //                     return Dialog(
  //                       child: ListView(
  //                           padding: const EdgeInsets.symmetric(
  //                               vertical: 16),
  //                           shrinkWrap: true,
  //                           children: [
  //                             'Delete',
  //                           ]
  //                               .map(
  //                                 (e) => InkWell(
  //                                 child: Container(
  //                                   padding:
  //                                   const EdgeInsets.symmetric(
  //                                       vertical: 12,
  //                                       horizontal: 16),
  //                                   child: Text(e),
  //                                 ),
  //                                 onTap: () {
  //                                   deletePost(
  //                                     widget.snap['postId']
  //                                         .toString(),
  //                                   );
  //                                   // remove the dialog box
  //                                   Navigator.of(context).pop();
  //                                 }),
  //                           )
  //                               .toList()),
  //                     );
  //                   },
  //                 );
  //               },
  //               icon: const Icon(Icons.more_vert),
  //             )
  //                 : Container(),
  //           ],
  //         ),
  //       ),
  //       // IMAGE SECTION OF THE POST
  //       GestureDetector(
  //         onDoubleTap: () {
  //           FireStoreMethods().likePost(
  //             widget.snap['postId'].toString(),
  //             user.uid,
  //             widget.snap['likes'],
  //           );
  //           setState(() {
  //             isLikeAnimating = true;
  //           });
  //         },
  //         child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.35,
  //               width: double.infinity,
  //               child: Image.network(
  //                 widget.snap['postUrl'].toString(),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             AnimatedOpacity(
  //               duration: const Duration(milliseconds: 200),
  //               opacity: isLikeAnimating ? 1 : 0,
  //               child: LikeAnimation(
  //                 isAnimating: isLikeAnimating,
  //                 child: const Icon(
  //                   Icons.favorite,
  //                   color: Colors.white,
  //                   size: 100,
  //                 ),
  //                 duration: const Duration(
  //                   milliseconds: 400,
  //                 ),
  //                 onEnd: () {
  //                   setState(() {
  //                     isLikeAnimating = false;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       // LIKE, COMMENT SECTION OF THE POST
  //       Row(
  //         children: <Widget>[
  //           LikeAnimation(
  //             isAnimating: widget.snap['likes'].contains(user.uid),
  //             smallLike: true,
  //             child: IconButton(
  //               icon: widget.snap['likes'].contains(user.uid)
  //                   ? const Icon(
  //                 Icons.favorite,
  //                 color: Colors.red,
  //               )
  //                   : const Icon(
  //                 Icons.favorite_border,
  //               ),
  //               onPressed: () => FireStoreMethods().likePost(
  //                 widget.snap['postId'].toString(),
  //                 user.uid,
  //                 widget.snap['likes'],
  //               ),
  //             ),
  //           ),
  //           IconButton(
  //             icon: const Icon(
  //               Icons.comment_outlined,
  //             ),
  //             onPressed: () => Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) => CommentsScreen(
  //                   postId: widget.snap['postId'].toString(),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           IconButton(
  //               icon: const Icon(
  //                 Icons.send,
  //               ),
  //               onPressed: () {}),
  //           Expanded(
  //               child: Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: IconButton(
  //                     icon: const Icon(Icons.bookmark_border), onPressed: () {}),
  //               ))
  //         ],
  //       ),
  //       //DESCRIPTION AND NUMBER OF COMMENTS
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             DefaultTextStyle(
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .subtitle2!
  //                     .copyWith(fontWeight: FontWeight.w800),
  //                 child: Text(
  //                   '${widget.snap['likes'].length} likes',
  //                   style: Theme.of(context).textTheme.bodyText2,
  //                 )),
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.only(
  //                 top: 8,
  //               ),
  //               child: RichText(
  //                 text: TextSpan(
  //                   style: const TextStyle(color: primaryColor),
  //                   children: [
  //                     TextSpan(
  //                       text: widget.snap['username'].toString(),
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: ' ${widget.snap['description']}',
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             InkWell(
  //               child: Container(
  //                 child: Text(
  //                   'View all $commentLen comments',
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     color: secondaryColor,
  //                   ),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(vertical: 4),
  //               ),
  //               onTap: () => Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                   builder: (context) => CommentsScreen(
  //                     postId: widget.snap['postId'].toString(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               child: Text(
  //                 DateFormat.yMMMd()
  //                     .format(widget.snap['datePublished'].toDate()),
  //                 style: const TextStyle(
  //                   color: secondaryColor,
  //                 ),
  //               ),
  //               padding: const EdgeInsets.symmetric(vertical: 4),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   ),
  // );
  // }
}
