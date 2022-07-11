import 'dart:developer';
import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/model/friend_request_model.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/model/relationship_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/domain/repository/post_repository.dart';
import 'package:ccvc_mobile/domain/repository/user_repository.dart';
import 'package:ccvc_mobile/presentation/profile/bloc/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

enum RelationshipType {
  friend,
  requestSender,
  requestReceiver,
  blocked,
  stranger,
  owner
}

class ProfileCubit extends BaseCubit<ProfileState> {
  ProfileCubit() : super(ProfileStateInitial()) {
    // userId =  PrefsService.getUserId();
    // log(userId);
    // getUserInfo(userId);
    // getAllPosts();
  }

  // String userId='';
  final BehaviorSubject<List<PostModel>> _posts =
      BehaviorSubject<List<PostModel>>.seeded([]);

  Stream<List<PostModel>> get posts => _posts.stream;

  final BehaviorSubject<List<PostModel>> _friendsList =
      BehaviorSubject<List<PostModel>>.seeded([]);

  Stream<List<PostModel>> get friendsList => _friendsList.stream;

  final BehaviorSubject<UserModel> _user =
      BehaviorSubject<UserModel>.seeded(UserModel());

  Stream<UserModel> get user => _user.stream;
  final BehaviorSubject<RelationshipType> _relationshipType =
      BehaviorSubject<RelationshipType>.seeded(RelationshipType.stranger);

  Stream<RelationshipType> get relationshipType => _relationshipType.stream;
  PostRepository _postRepository = PostRepository();
  UserRepopsitory _userRepopsitory = UserRepopsitory();
  Future<void> getAllPosts(String userId) async {
    //  log(DateTime.now().toString());
    try {
      log('hihi');
      FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.postsCollection)
          .where('user_id', isEqualTo: userId)
          // .orderBy('create_at', descending: true)
          .snapshots()
          .listen((event) async {
        log('hihi');
        if (event.docs == null || event.docs.isEmpty) {
          log('hihi');
          _posts.sink.add([]);
          showContent();
          return null;
        } else {
          List<PostModel> posts = [];
          log(event.docs.length.toString());
          for (var x in event.docs) {
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
          _posts.sink.add(posts);
          showContent();
        }
      });
    } catch (e) {
      log('hahahahahhaa');
      log(e.toString());
      showError();
    }
  }

  Future<void> getRelationship(String userId) async {
    showLoading();
    try {
      String ownerId = await PrefsService.getUserId();
      if (userId == ownerId) {
        _relationshipType.sink.add(RelationshipType.owner);
      } else {
        final result = await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.usersCollection)
            .doc(userId)
            .collection('relationships')
            //    .where('user_id1', isEqualTo: ownerId)
            .where('user_id2', isEqualTo: ownerId)

            // .where(('userId1' == userId && 'userId2' == ownerId) ||
            //     ('userId2' == userId && 'userId1' == ownerId))
            .get();
        log('friend');
        log(result.size.toString());
        if (result.docs != null && result.size != 0) {
          result.docs.first.data()['type'] == 1
              ? _relationshipType.sink.add(RelationshipType.friend)
              : _relationshipType.sink.add(RelationshipType.blocked);
        } else {
          final result = await FirebaseFirestore.instance
              .collection(DefaultEnv.appCollection)
              .doc(DefaultEnv.developDoc)
              .collection(DefaultEnv.usersCollection)
              .doc(userId)
              .collection('friend_requests')
              .where('sender', isEqualTo: userId)
              .where('receiver', isEqualTo: ownerId)
              .get();
          if (result.docs != null && result.size != 0) {
            _relationshipType.sink.add(RelationshipType.requestReceiver);
          } else {
            final result = await FirebaseFirestore.instance
                .collection(DefaultEnv.appCollection)
                .doc(DefaultEnv.developDoc)
                .collection(DefaultEnv.usersCollection)
                .doc(userId)
                .collection('friend_requests')
                .where('sender', isEqualTo: ownerId)
                .where('receiver', isEqualTo: userId)
                .get();
            if (result.docs != null && result.size != 0) {
              _relationshipType.sink.add(RelationshipType.requestSender);
            } else {
              log('mmmmmmmmmmmmmmmmmm');
              _relationshipType.sink.add(RelationshipType.stranger);
            }
          }
        }
      }
    } catch (e) {
      log(e.toString());
      log('pppppppppppppppppppp');
      showError();
      _relationshipType.sink.add(RelationshipType.stranger);
    }
  }

  Future<void> getUserInfo(userId) async {
    log('lllllllllllllllllllll' + userId);
    showLoading();
    try {
      //    final result = await _userRepopsitory.getUserProfile(userId: userId);
      FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId)
          .collection('profile')
          .snapshots()
          .listen((event) async {
        if (event.docs == null) {
          return null;
        } else {
          Map<String, dynamic> data = Map<String, dynamic>();
          for (var y in event.docs) {
            data = y.data();
            data.addAll({'user_id': userId});
          }

          _user.sink.add(UserModel.fromJson(data));
        }
      });
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  Future<void> sendFriendRequest() async {
    // showLoading();
    try {
      final ownerId = await PrefsService.getUserId();
      FriendRequestModel newRequest = FriendRequestModel(
          sender: UserModel(userId: ownerId),
          receiver: UserModel(userId: _user.value.userId),
          createAt: DateTime.now().millisecondsSinceEpoch,
          updateAt: DateTime.now().millisecondsSinceEpoch);
      final result = await _userRepopsitory.sendFriendRequest(
          friendRequestModel: newRequest);
      if (result) {
        log('pppp' + result.toString());
        _relationshipType.sink.add(RelationshipType.requestSender);
        //   showContent();
      } else {
        showError();
      }
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  Future<void> acceptFriendRequest() async {
    showLoading();
    try {
      final ownerId = await PrefsService.getUserId();
      final result = await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(_user.value.userId)
          .collection('friend_requests')
          .where('sender', isEqualTo: _user.value.userId)
          .where('receiver', isEqualTo: ownerId)
          .get();

      final resultAccept = await _userRepopsitory.acceptFriendRequest(
          userId1: ownerId,
          userId2: _user.value.userId ?? '',
          requestId: result.docs.first.id);
      if (resultAccept) {
        log('pppp' + resultAccept.toString());
        _relationshipType.sink.add(RelationshipType.friend);
        showContent();
      } else {
        showError();
      }
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  Future<void> cancelOrDeclineFriendRequest() async {
    // showLoading();
    log('vvvvvvvvvvvvvvv' + _user.value.userId.toString());
    try {
      final ownerId = await PrefsService.getUserId();
      late var result;
      if (_relationshipType.value == RelationshipType.requestSender) {
        result = await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.usersCollection)
            .doc(_user.value.userId ?? '')
            .collection('friend_requests')
            .where('sender', isEqualTo: ownerId)
            .where('receiver', isEqualTo: _user.value.userId)
            .get();
      } else if (_relationshipType.value == RelationshipType.requestReceiver) {
        result = await FirebaseFirestore.instance
            .collection(DefaultEnv.appCollection)
            .doc(DefaultEnv.developDoc)
            .collection(DefaultEnv.usersCollection)
            .doc(_user.value.userId ?? '')
            .collection('friend_requests')
            .where('sender', isEqualTo: _user.value.userId)
            .where('receiver', isEqualTo: ownerId)
            .get();
      }
      log('pppp' + result.docs.first.data().toString());
      FriendRequestModel requestModel =
          FriendRequestModel.fromJson(result.docs.first.data());
      requestModel.requestId = result.docs.first.id;
      requestModel.sender =
          UserModel(userId: result.docs.first.data()['sender']);
      requestModel.receiver =
          UserModel(userId: result.docs.first.data()['receiver']);
      final resultdecline = await _userRepopsitory.cancelOrDeclineFriendRequest(
          requestModel: requestModel);
      if (resultdecline) {
        _relationshipType.sink.add(RelationshipType.stranger);
        //   showContent();
      } else {
        showError();
      }
    } catch (e) {
      log('lllllllllllllllllllllllllllll');
      log(e.toString());
      showError();
    }
  }

  Future<void> discardRelationship() async {
    // showLoading();
    log('vvvvvvvvvvvvvvv' + _user.value.userId.toString());
    try {
      final ownerId = await PrefsService.getUserId();
      log(ownerId);
      final result = await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(_user.value.userId)
          .collection('relationships')
          .where('user_id2', isEqualTo: ownerId)
          .get();
      log(result.docs.toString());
      RelationshipModel rela = RelationshipModel(
          user2: UserModel(userId: ownerId),
          user1: UserModel(userId: _user.value.userId),
          createAt: DateTime.now().millisecondsSinceEpoch,
          updateAt: DateTime.now().millisecondsSinceEpoch,
          type: 1,
          relationshipId: result.docs.first.id);
      final resultdecline =
          await _userRepopsitory.discardRelationship(relationshipModel: rela);
      if (resultdecline) {
        _relationshipType.sink.add(RelationshipType.stranger);
        //   showContent();
      } else {
        showError();
      }
    } catch (e) {
      log('lllllllllllllllllllllllllllll');
      log(e.toString());
      showError();
    }
  }

  Future<void> block(context) async {
    showLoading();
    try {
      final ownerId = await PrefsService.getUserId();
      RelationshipModel newRela = RelationshipModel(
          user1: UserModel(userId: ownerId),
          user2: UserModel(userId: _user.value.userId ?? ''),
          createAt: DateTime.now().millisecondsSinceEpoch,
          updateAt: DateTime.now().millisecondsSinceEpoch,
          type: 2);
      switch (_relationshipType.value) {
        case RelationshipType.stranger:
          final result = await _userRepopsitory.blockUser(
            userId1: ownerId,
            userId2: _user.value.userId ?? '',
          );
          if (result) {
            _relationshipType.sink.add(RelationshipType.blocked);
            Navigator.pop(context);
          } else {
            showError();
          }
          break;
        case RelationshipType.friend:
          final result = await FirebaseFirestore.instance
              .collection(DefaultEnv.appCollection)
              .doc(DefaultEnv.developDoc)
              .collection(DefaultEnv.usersCollection)
              .doc(_user.value.userId)
              .collection('relationships')
              .where('user_id2', isEqualTo: ownerId)
              .get();
          log(result.docs.toString());
          RelationshipModel rela = RelationshipModel(
              user2: UserModel(userId: ownerId),
              user1: UserModel(userId: _user.value.userId),
              createAt: DateTime.now().millisecondsSinceEpoch,
              updateAt: DateTime.now().millisecondsSinceEpoch,
              type: 1,
              relationshipId: result.docs.first.id);
          final resultDiscard = await _userRepopsitory.discardRelationship(
              relationshipModel: rela);
          if (resultDiscard) {
            final resultBlock = await _userRepopsitory.blockUser(
              userId1: ownerId,
              userId2: _user.value.userId ?? '',
            );
            if (resultBlock) {
              _relationshipType.sink.add(RelationshipType.blocked);
              Navigator.pop(context);
            } else {
              showError();
            }
            Navigator.pop(context);
          } else {
            showError();
          }

          break;
        case RelationshipType.requestReceiver:
        case RelationshipType.requestSender:
          final ownerId = await PrefsService.getUserId();
          final result = await FirebaseFirestore.instance
              .collection(DefaultEnv.appCollection)
              .doc(DefaultEnv.developDoc)
              .collection(DefaultEnv.usersCollection)
              .doc(_user.value.userId ?? '')
              .collection('friend_requests')
              .where('sender', isEqualTo: ownerId)
              .where('receiver', isEqualTo: _user.value.userId)
              .get();
          log('pppp' + result.docs.first.data().toString());
          FriendRequestModel requestModel =
              FriendRequestModel.fromJson(result.docs.first.data());
          requestModel.requestId = result.docs.first.id;
          requestModel.sender =
              UserModel(userId: result.docs.first.data()['sender']);
          requestModel.receiver =
              UserModel(userId: result.docs.first.data()['receiver']);
          final resultdecline = await _userRepopsitory
              .cancelOrDeclineFriendRequest(requestModel: requestModel);
          if (resultdecline) {
            final result = await _userRepopsitory.blockUser(
              userId1: ownerId,
              userId2: _user.value.userId ?? '',
            );
            if (result) {
              _relationshipType.sink.add(RelationshipType.blocked);
              Navigator.pop(context);
            } else {
              showError();
            }
            Navigator.pop(context);
          } else {
            showError();
          }
          break;
      }
      showContent();
    } catch (e) {
      log('lllllllllllllllllllllllllllll');
      log(e.toString());
      showError();
    }
  }
}
