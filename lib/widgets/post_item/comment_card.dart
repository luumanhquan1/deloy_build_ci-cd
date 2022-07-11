import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/config/themes/theme_color.dart';
import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/repository/post_repository.dart';
import 'package:ccvc_mobile/utils/app_utils.dart';
import 'package:ccvc_mobile/widgets/app_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CommentCard extends StatelessWidget {
  final CommentModel commentModel;
  final bool canDelete;
  final Function() onTapName;
  const CommentCard(
      {Key? key, required this.commentModel, required this.canDelete,required this.onTapName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: onTapName,
            child: ClipRRect(
              child: Container(
                width: 40.sp,
                height: 40.sp,
                child: commentModel.author == null ||
                        commentModel.author!.avatarUrl!.isEmpty
                    ? Container(
                        color: ThemeColor.ebonyClay,
                      )
                    : AppImage.network(path: commentModel.author!.avatarUrl!),
              ),
              borderRadius: BorderRadius.circular(80),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${commentModel.author?.nameDisplay ?? ''}  ',
                            recognizer: TapGestureRecognizer()..onTap = onTapName,
                            style: username(
                                color: ThemeColor.black.withOpacity(0.7))),
                        TextSpan(
                          text: commentModel.data ?? '',
                          style:
                              caption(color: ThemeColor.black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Text(
                          parseTimeCreate(commentModel.createAt ?? 0),
                          style:
                              detail(color: ThemeColor.black.withOpacity(0.7)),
                        ),
                        if (canDelete) Padding(
                              padding:  EdgeInsets.only(left: 16.sp),
                              child: GestureDetector(
                                  onTap: () async {
                                    final result = await showOkCancelAlertDialog(
                                      context: context,
                                      title: 'Xóa bình luận',
                                      message: 'Bạn có muốn xóa bình luận này?',
                                      okLabel: 'Xóa',
                                      cancelLabel: 'Hủy',
                                      fullyCapitalizedForMaterial: false,
                                    );
                                    log(result.name.toString());

                                    if (result.name == 'ok') {
                                      await PostRepository().deleteComment(
                                          commentModel.postId!,
                                          commentModel.commentId!);
                                    }
                                  },
                                  child: Text(
                                    'Xóa',
                                    style: detail(
                                        color: ThemeColor.black.withOpacity(0.7)),
                                  )),
                            ) else const SizedBox()
                      ],
                    ),
                  )
                ],
              ),

            ),
          ),

        ],
      ),
    );
  }
}
