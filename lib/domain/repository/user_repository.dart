import 'dart:developer';

import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/config/firebase_config.dart';
import 'package:ccvc_mobile/domain/model/friend_request_model.dart';
import 'package:ccvc_mobile/domain/model/relationship_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class UserRepopsitory {
  FirebaseSetup firebaseSetup = FirebaseSetup();

  Future<UserModel?> getUserProfile({required String userId}) async {
    final response = await FirebaseFirestore.instance
        .collection(DefaultEnv.appCollection)
        .doc(DefaultEnv.developDoc)
        .collection(DefaultEnv.usersCollection)
        .doc(userId)
        .collection('profile')
        .get();
    // firebaseSetup.usersCollection.doc(userId).collection(DefaultEnv.profileCollection).get();
    if (response.docs == null) {
      return null;
    } else {
      Map<String, dynamic> data = Map<String, dynamic>();
      for (var y in response.docs) {
        data = y.data();
        data.addAll({'user_id': userId});
        log('1111' + data.toString());
        return UserModel.fromJson(data);
      }
      return UserModel.fromJson(data);
    }
  }

  Future<bool> updateOnline(
      {required String userId, required bool onlineFlag}) async {
    try {
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId)
          .update({'online_flag': onlineFlag});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<RelationshipModel>> fetchFriendsList(String userId) async {
    final response = await FirebaseFirestore.instance
        .collection(DefaultEnv.appCollection)
        .doc(DefaultEnv.developDoc)
        .collection(DefaultEnv.usersCollection)
        .doc(userId)
        .collection('relationships')
        .where('type' == 1)
        .get();
    if (response.docs == null) {
      return [];
    } else {
      List<RelationshipModel> friends = [];
      log(response.docs.length.toString());
      for (var x in response.docs) {
        Map<String, dynamic> friend = {};
        friend.addAll({'relationship_id': x.id});
        friend.addAll(x.data());

        RelationshipModel newFriend = RelationshipModel.fromJson(friend);

        //get user1
        final user1 =
            await UserRepopsitory().getUserProfile(userId: friend['user_id1']);
        newFriend.user1 = user1;

        //get user2
        final user2 =
            await UserRepopsitory().getUserProfile(userId: friend['user_id2']);
        newFriend.user2 = user2;

        friends.add(newFriend);
      }

      return friends;
    }
  }

  Future<List<FriendRequestModel>> fetchFriendRequests(String userId) async {
    final response = await FirebaseFirestore.instance
        .collection(DefaultEnv.appCollection)
        .doc(DefaultEnv.developDoc)
        .collection(DefaultEnv.usersCollection)
        .doc(userId)
        .collection('friend_requests')
        .get();
    if (response.docs == null) {
      return [];
    } else {
      List<FriendRequestModel> friendrequests = [];
      log(response.docs.length.toString());
      for (var x in response.docs) {
        Map<String, dynamic> request = {};
        request.addAll({'request_id': x.id});
        request.addAll(x.data());

        FriendRequestModel newRequest = FriendRequestModel.fromJson(request);

        //get sender
        final sender =
            await UserRepopsitory().getUserProfile(userId: request['sender']);
        newRequest.sender = sender;

        //get receiver
        final receiver =
            await UserRepopsitory().getUserProfile(userId: request['receiver']);
        newRequest.receiver = receiver;

        friendrequests.add(newRequest);
      }

      return friendrequests;
    }
  }

  // send friend request
  Future<bool> sendFriendRequest(
      {required FriendRequestModel friendRequestModel}) async {
    try {
      // if the likes list contains the user uid, we need to remove it
      String requestId = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(friendRequestModel.sender?.userId ?? '')
          .collection('friend_requests')
          .doc(requestId)
          .set(friendRequestModel.toJson());
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(friendRequestModel.receiver?.userId ?? '')
          .collection('friend_requests')
          .doc(requestId)
          .set(friendRequestModel.toJson());
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(friendRequestModel.sender?.userId ?? '')
          .update({'update_at': DateTime.now().millisecondsSinceEpoch});
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(friendRequestModel.receiver?.userId ?? '')
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

  Future<bool> acceptFriendRequest(
      {required String userId1,
      required String userId2,
      required String requestId}) async {
    try {
      // if the likes list contains the user uid, we need to remove it
      String relationshipId = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId1)
          .collection('relationships')
          .doc(relationshipId)
          .set(RelationshipModel(
                  user1: UserModel(userId: userId1),
                  user2: UserModel(userId: userId2),
                  createAt: DateTime.now().millisecondsSinceEpoch,
                  updateAt: DateTime.now().millisecondsSinceEpoch,
                  type: 1)
              .toJson());
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId2)
          .collection('relationships')
          .doc(relationshipId)
          .set(RelationshipModel(
                  user1: UserModel(userId: userId2),
                  user2: UserModel(userId: userId1),
                  createAt: DateTime.now().millisecondsSinceEpoch,
                  updateAt: DateTime.now().millisecondsSinceEpoch,
                  type: 1)
              .toJson());

      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId1)
          .collection('friend_requests')
          .doc(requestId)
          .delete();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId2)
          .collection('friend_requests')
          .doc(requestId)
          .delete();

      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId1)
          .update({'update_at': DateTime.now().millisecondsSinceEpoch});
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId2)
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

  Future<bool> cancelOrDeclineFriendRequest(
      {required FriendRequestModel requestModel}) async {
    log(requestModel.requestId.toString());
    try {
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(requestModel.sender?.userId ?? '')
          .collection('friend_requests')
          .doc(requestModel.requestId)
          .delete();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(requestModel.receiver?.userId ?? '')
          .collection('friend_requests')
          .doc(requestModel.requestId)
          .delete();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(requestModel.sender?.userId ?? '')
          .update({'update_at': DateTime.now().millisecondsSinceEpoch});
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(requestModel.receiver?.userId ?? '')
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

  Future<bool> discardRelationship(
      {required RelationshipModel relationshipModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(relationshipModel.user1?.userId ?? '')
          .collection('relationships')
          .doc(relationshipModel.relationshipId)
          .delete();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(relationshipModel.user2?.userId ?? '')
          .collection('relationships')
          .doc(relationshipModel.relationshipId)
          .delete();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(relationshipModel.user2?.userId ?? '')
          .update({'update_at': DateTime.now().millisecondsSinceEpoch});
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(relationshipModel.user1?.userId ?? '')
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

  // block user
  Future<bool> blockUser({required String userId1,
    required String userId2}) async {
    try {
      // if the likes list contains the user uid, we need to remove it
      String requestId = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId1)
          .collection('relationships')
          .doc(requestId)
          .set(RelationshipModel(
          user1: UserModel(userId: userId1),
          user2: UserModel(userId: userId2),
          createAt: DateTime.now().millisecondsSinceEpoch,
          updateAt: DateTime.now().millisecondsSinceEpoch,
          type: 2).toJson());

      await FirebaseFirestore.instance
          .collection(DefaultEnv.appCollection)
          .doc(DefaultEnv.developDoc)
          .collection(DefaultEnv.usersCollection)
          .doc(userId2)
          .collection('relationships')
          .doc(requestId)
          .set(RelationshipModel(
          user1: UserModel(userId: userId2),
          user2: UserModel(userId: userId1),
          createAt: DateTime.now().millisecondsSinceEpoch,
          updateAt: DateTime.now().millisecondsSinceEpoch,
          type: 2).toJson());
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
}
