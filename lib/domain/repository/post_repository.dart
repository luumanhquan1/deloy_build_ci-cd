import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/config/firebase_config.dart';
import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PostRepository {
  FirebaseSetup firebaseSetup = FirebaseSetup();

  Future<List<PostModel>> fetchAllPost() async {
    final response =
        await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .orderBy('create_at', descending: true)
            // .orderBy('create_at')
            // .limit(10)
            .get();
    if (response.docs == null) {
      return [];
    } else {
      List<PostModel> posts = [];
      log(response.docs.length.toString());
      for (var x in response.docs) {
        log('huhu');
        Map<String, dynamic> post = {};
        post.addAll({'post_id': x.id});
        post.addAll(x.data());
        log(post.toString());

        PostModel newPost = PostModel.fromJson(post);

        //get user
        final user =
            await UserRepopsitory().getUserProfile(userId: post['user_id']);
        newPost.author = user;

        //get comments
        final comments = await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .doc(x.id)
            .collection('comments')
            .orderBy('create_at', descending: true)
            .get();
        List<CommentModel> cmts = [];
        for (var cmt in comments.docs) {
          cmt.data().addAll({'comment_id': cmt.id});
          CommentModel commentModel = CommentModel.fromJson(cmt.data());
          cmts.add(commentModel);
        }
        newPost.comments = cmts;
        debugPrint(newPost.toString());
        posts.add(newPost);
      }

      return posts;
    }
  }

  Future<PostModel?> fetchPost(String postId) async {
    final response =
        await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .doc(postId)
            .get();
    if (response.data() == null) {
      return null;
    } else {
      Map<String, dynamic> post = {};
      post.addAll({'post_id': response.id});
      post.addAll(response.data() ?? {});
      log(post.toString());

      PostModel newPost = PostModel.fromJson(post);

      //get user
      final user =
          await UserRepopsitory().getUserProfile(userId: post['user_id']);
      newPost.author = user;

      //get comments
      final comments = await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .doc(response.id)
          .collection('comments')
          .orderBy('create_at', descending: true)
          .get();
      List<CommentModel> commentsList = [];
      for (var cmt in comments.docs) {
        CommentModel cmtmodel = CommentModel.fromJson(cmt.data());
        final user = await UserRepopsitory()
            .getUserProfile(userId: cmt.data()['user_id']);
        cmtmodel.commentId = cmt.id;
        cmtmodel.author = user;
        cmtmodel.postId = response.id;
        commentsList.add(cmtmodel);
        debugPrint(cmtmodel.toString());
      }
      newPost.comments = commentsList;

      return newPost;
    }
  }

  Future<List<PostModel>> fetchAllPostOfUser(String userId) async {
    final response =
    await FirebaseFirestore.instance
        .collection(DefaultEnv.appCollection)
        .doc(DefaultEnv.developDoc)
        .collection(DefaultEnv.postsCollection).where('user_id' == userId)
        .orderBy('create_at', descending: true)
    // .orderBy('create_at')
    // .limit(10)
        .get();
    if (response.docs == null) {
      return [];
    } else {
      List<PostModel> posts = [];
      log(response.docs.length.toString());
      for (var x in response.docs) {
        Map<String, dynamic> post = {};
        post.addAll({'post_id': x.id});
        post.addAll(x.data());
        log(post.toString());

        PostModel newPost = PostModel.fromJson(post);

        //get user
        final user =
        await UserRepopsitory().getUserProfile(userId: post['user_id']);
        newPost.author = user;

        //get comments
        final comments = await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .doc(x.id)
            .collection('comments')
            .orderBy('create_at', descending: true)
            .get();
        List<CommentModel> cmts = [];
        for (var cmt in comments.docs) {
          cmt.data().addAll({'comment_id': cmt.id});
          CommentModel commentModel = CommentModel.fromJson(cmt.data());
          cmts.add(commentModel);
        }
        newPost.comments = cmts;
        debugPrint(newPost.toString());
        posts.add(newPost);
      }

      return posts;
    }
  }


  // Future<String> uploadPost(String description, Uint8List file, String uid,
  //     String username, String profImage) async {
  //   // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
  //   String res = "Some error occurred";
  //   try {
  //     String photoUrl =
  //     await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1(); // creates unique id based on time
  //     Post post = Post(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       likes: [],
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //     );
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
  //
  Future<bool> likePost(String postId, String uid, List likes) async {
    log(postId + ' rrr  ' + uid);
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .doc(postId)
            .update({
          'update_at': DateTime.now().millisecondsSinceEpoch,
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.postsCollection)
            .doc(postId)
            .update({
          'update_at': DateTime.now().millisecondsSinceEpoch,
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      return true;
    } catch (err) {
      log(err.toString());
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi. Vui lòng thử lại sau",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
  }

  // Post comment
  Future<bool> postComment({required CommentModel commentModel}) async {
    try {
      // if the likes list contains the user uid, we need to remove it
      String commentId = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .doc(commentModel.postId)
          .collection('comments')
          .doc(commentId)
          .set(commentModel.ToJson());

      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .doc(commentModel.postId)
          .update({'update_at': DateTime.now().millisecondsSinceEpoch});
    } catch (err) {
      log(err.toString());
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi. Vui lòng thử lại sau",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
    return true;
  }

  // Delete Post
  Future<bool> deletePost(String postId) async {
    try {
      log('deleteeeee');
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .doc(postId)
          .delete();
    } catch (err) {
      log(err.toString());
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi. Vui lòng thử lại sau",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
    return true;
    ;
  }

  // Delete Post
  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      log('deleteeeee');
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .doc(postId)
          .update({'update_at': DateTime.now().millisecondsSinceEpoch});
    } catch (err) {
      log(err.toString());
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi. Vui lòng thử lại sau",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
    return true;
    ;
  }
}
