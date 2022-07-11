import 'dart:developer';

import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/domain/repository/post_repository.dart';
import 'package:ccvc_mobile/domain/repository/user_repository.dart';
import 'package:ccvc_mobile/presentation/post/bloc/post_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class PostCubit extends BaseCubit<PostState> {
  PostCubit(String postId) : super(PostState()){
    userId =  PrefsService.getUserId();
    log(userId);
    getUserInfo(userId);
    updatePost(postId);

  }
 final BehaviorSubject<PostModel> _posts =
  BehaviorSubject<PostModel>.seeded(PostModel());
  String userId='';
  Stream<PostModel> get post => _posts.stream;
  // //
  // // final BehaviorSubject<int> _unreadNotis =
  // // BehaviorSubject<int>.seeded(0);
  // //
  // // Stream<int> get unreadNotis => _unreadNotis.stream;
  //
  // final BehaviorSubject<PostState> _postState =
  // BehaviorSubject<PostState>.seeded(PostState(post: PostModel(), isLoading: false));
  //
  // Stream<PostState> get postState => _postState.stream;

  final BehaviorSubject<UserModel> _user =
      BehaviorSubject<UserModel>.seeded(UserModel());

  Stream<UserModel> get user => _user.stream;

  PostRepository _postRepository = PostRepository();
  UserRepopsitory _userRepopsitory = UserRepopsitory();

  void updatePost(String postId) {
    FirebaseFirestore.instance
        .collection(DefaultEnv.appCollection)
        .doc(DefaultEnv.developDoc)
        .collection(DefaultEnv.postsCollection)
        .doc(postId)
        .snapshots()
        .listen((event) async {
      if (event.data() == null) {
        return null;
      } else {
        log('updateeeeeeeeeeeeeeeeeeeeeee');
        Map<String, dynamic> post = {};
        post.addAll({'post_id': event.id});
        post.addAll(event.data()!);
        final comments = await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .doc(event.id)
            .collection('comments').orderBy('create_at',descending: true)
            .get();
        //post.addAll({'comments':comments.docs});
        PostModel newPost = PostModel.fromJson(post);
        final user =
            await UserRepopsitory().getUserProfile(userId: post['user_id']);
        newPost.author = user;
        List<CommentModel> commentsList = [];
        for (var cmt in comments.docs) {
          CommentModel cmtmodel = CommentModel.fromJson(cmt.data());
          final user = await UserRepopsitory()
              .getUserProfile(userId: cmt.data()['user_id']);
          cmtmodel.commentId = cmt.id;
          cmtmodel.author = user;
          cmtmodel.postId = event.id;
          commentsList.add(cmtmodel);
        }
        newPost.comments = commentsList;
        debugPrint(newPost.toString());
        _posts.sink.add(newPost);
      }

    });

  }

  Future<void> commentPost(
      {required String postId,
      required String data,}) async {
    CommentModel newComment = CommentModel(
        postId: postId,
        data: data,
        createAt: DateTime.now().millisecondsSinceEpoch,
        author: _user.value);
    log(newComment.toString());
    try {
      final result =
          await _postRepository.postComment(commentModel: newComment);
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  Future<void> likePost(
      {required String postId, required List<String> likes}) async {
    try {
      log('gggggggg'+_user.value.toString());

      await _postRepository.likePost(
        postId,
        _user.value.userId!,
        likes,
      );
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  Future<void> deletePost({required String postId}) async {
    // try {
    //   await _postRepository.deletePost(
    //     postId,
    //   );
    // } catch (e) {
    //   log(e.toString());
    //   showError();
    // }
  }

  Future<void> getUserInfo(userId) async {
    showLoading();
    try {
      final result = await _userRepopsitory.getUserProfile(userId: userId);
      if (result != null) {
        _user.sink.add(result);
        showContent();
      } else {
        showError();
      }
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  // Future<void> getAllPosts() async{
  //   showLoading();
  //   try{
  //     final result = await _postRepository.fetchAllPost();
  //     _posts.sink.add(result);
  //     showContent();
  //   }catch (e){
  //     log(e.toString());
  //     showError();
  //   }
  // }

}
