import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/config/themes/theme_color.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/presentation/post/bloc/post_cubit.dart';
import 'package:ccvc_mobile/presentation/profile/ui/profile_screen.dart';
import 'package:ccvc_mobile/widgets/app_image.dart';
import 'package:ccvc_mobile/widgets/post_item/comment_card.dart';
import 'package:ccvc_mobile/widgets/post_item/post_item.dart';
import 'package:ccvc_mobile/widgets/post_item/post_item_skeleton.dart';
import 'package:ccvc_mobile/widgets/refresh_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key, required this.postId}) : super(key: key);

  String postId;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PostCubit _postCubit = PostCubit(widget.postId);
    return SafeArea(
        child: StreamBuilder<UserModel>(
            stream: _postCubit.user,
            builder: (context, user) {
              return StreamBuilder<PostModel>(
                  stream: _postCubit.post,
                  builder: (context, post) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: ThemeColor.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        centerTitle: true,
                        title: Text(
                          post.data?.author?.nameDisplay ?? '',
                          style: heading2(color: ThemeColor.black),
                        ),
                      ),
                      body: SingleChildScrollView(
                          child: user.data?.userId == null ||
                                  post.data == null ||
                                  post.data!.postId.isNullOrEmpty
                              ? PostItemSkeleton()
                              :
                              // if (post.connectionState == ConnectionState.waiting) {
                              //   return const Center(
                              //     child: CircularProgressIndicator(),
                              //   );
                              // }
                              //      return
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PostCard(
                                      postModel: post.data!,
                                      userId: user.data?.userId ?? '',
                                      onTapName: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userId: post.data?.author?.userId ??
                                          ''))),
                                    ),
                                    post.data!.comments == null
                                        ? SizedBox()
                                        : Container(
                                            // width: 200,
                                            // height: 200,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  post.data!.comments!.length,
                                              itemBuilder: (ctx, index) =>
                                                  CommentCard(
                                                    onTapName: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userId: post.data?.comments?[index].author?.userId ??
                                                        ''))),
                                                commentModel:
                                                    post.data!.comments![index],
                                                canDelete: (post
                                                            .data!
                                                            .comments![index]
                                                            .author!
                                                            .userId! ==
                                                        user.data!.userId) ||
                                                    (post.data!.author!
                                                            .userId ==
                                                        user.data!.userId),
                                              ),
                                            ),
                                          )
                                  ],
                                )),
                      //},

                      //   ),

                      // text input
                      bottomNavigationBar: SafeArea(
                        child: Container(
                          height: kToolbarHeight,
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          padding: EdgeInsets.only(left: 16.sp, right: 8.sp),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Container(
                                    width: 40.sp,
                                    height: 40.sp,
                                    child: user.data?.avatarUrl == null
                                        ? Container(
                                            color: ThemeColor.ebonyClay,
                                          )
                                        : AppImage.network(
                                            path: user.data!.avatarUrl!)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, right: 8),
                                  child: TextField(
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      //    hintText: 'Comment as ${user.username}',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (commentController.text
                                      .trim()
                                      .isNotEmpty) {
                                    _postCubit.commentPost(
                                      postId: post.data?.postId ?? '',
                                      data: commentController.text.trim(),
                                    );
                                  }
                                  commentController.text = '';
                                  FocusScope.of(context).unfocus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  child: const Text(
                                    'Post',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
