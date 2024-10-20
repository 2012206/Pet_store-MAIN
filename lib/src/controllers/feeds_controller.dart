import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/bottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedsController extends GetxController {
  Rx<File> image = File('').obs;
  User? user = FirebaseAuth.instance.currentUser;
  RxList feedList = [].obs;
  RxList<model.CommentsOnFeed> comments = <model.CommentsOnFeed>[].obs;
  RxList<model.LikesOnFeed> likes = <model.LikesOnFeed>[].obs;
  RxList<model.RepliesOnFeed> replyOnCommentFeed = <model.RepliesOnFeed>[].obs;

  Future pickImage(ImageSource source) async {
    try {
      final imagePick = await ImagePicker().pickImage(source: source);
      if (imagePick == null) {
        return;
      }
      final imageTemp = File(imagePick.path);
      image.value = imageTemp;
    } on PlatformException catch (e) {
      return e;
    }
  }

  addPost({required String title}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('userName');

    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference reference =
        FirebaseStorage.instance.ref().child('posts/$fileName.png');
    await reference.putFile(image.value);

    String downloadURL = await reference.getDownloadURL();
    model.Feeds feed = model.Feeds(
        postId: random,
        image: downloadURL,
        ownerName: username,
        title: title,
        userUid: user!.uid,
        timeStamp: DateTime.now().toString());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("feeds")
        .doc(random)
        .set(feed.toJson());
  }

  Future<int> addLikeOnPost(String userId, String postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('userName');
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('feeds')
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likes = data['likes'] ?? [];

      if (!likes.contains(username)) {
        likes.add(username);
        await postRef.update({'likes': likes});
      }

      return likes.length;
    }
    return 0;
  }

  void updateLikeCount(int index, int newLikeCount) {
    feedList[index].likes = newLikeCount;
    feedList.refresh();
  }

  Future<void> getLikesOnPost(String userId, String postId) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('feeds')
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likesData = data['likes'] ?? [];

      print('Raw Likes Data: $likesData'); // Debugging: Print raw likes data

      // Clear existing likes list and add new likes
      likes.clear();
      likesData.forEach((likeData) {
        model.LikesOnFeed like = model.LikesOnFeed(name: likeData);
        likes.add(like);
      });

      print('Processed Likes: $likes'); // Debugging: Print processed likes list
    }
  }

  Future<int> getLikeCount(String userId, String postId) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('feeds')
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likes = data['likes'] ?? [];
      return likes.length;
    }
    return 0;
  }

  void addCommentOnPost(String userId, String postId, String comment) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('userName');
    // Get a reference to the post document
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('feeds')
        .doc(postId);

    // Get the current data of the post
    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> comments = data['comments'] ?? [];

      // Create a new comment object
      model.CommentsOnFeed newComment =
          model.CommentsOnFeed(name: username, comment: comment);

      // Convert the comment object to JSON and add it to the list of comments
      comments.add(newComment.toJson());

      // Update the post document with the new comments list
      await postRef.update({'comments': comments});
    }
  }

  void addReplyToComment(
    String userId,
    String postId,
    int index,
    String reply,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('userName');
      DocumentReference feedRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feeds')
          .doc(postId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(feedRef);
        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            List<dynamic> comments = data['comments'];
            // Ensure that the 'replies' list exists before attempting to add a reply
            if (comments[index]['replies'] == null) {
              comments[index]['replies'] = <Map<String, dynamic>>[];
            }
            List<dynamic> replies = comments[index]['replies'];
            model.RepliesOnFeed newReply =
                model.RepliesOnFeed(name: username, reply: reply);
            replies.add(newReply.toJson());
            comments[index]['replies'] = replies;
            transaction.update(feedRef, {'comments': comments});
          } else {
            print('Document data is null');
          }
        } else {
          print('Document does not exist');
        }
      });

      print('Reply added successfully');
    } catch (e) {
      print('Error adding reply: $e');
    }
  }

  Future<List<dynamic>> getRepliesForComment(
      String userId, String postId, int index) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feeds')
          .doc(postId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          List<dynamic> comments = data['comments'];
          if (comments[index]['replies'] != null) {
            return List.from(comments[index]['replies']);
          } else {
            return [];
          }
        } else {
          print('Document data is null');
          return [];
        }
      } else {
        print('Document does not exist');
        return [];
      }
    } catch (e) {
      print('Error getting replies: $e');
      return [];
    }
  }

  Future<void> fetchAndSetReplies(
      String userId, String postId, int commentIndex) async {
    try {
      List<dynamic> replies =
          await getRepliesForComment(userId, postId, commentIndex);
      // Clear the existing list and add new replies
      replyOnCommentFeed.clear();
      for (var replyMap in replies) {
        replyOnCommentFeed.add(model.RepliesOnFeed.fromJson(replyMap));
      }
      print(replyOnCommentFeed);
    } catch (e) {
      print('Error fetching and setting replies: $e');
    }
  }

  // void addReplyToComment(
  //   String userId,
  //   String postId,
  //   String parentCommentId,
  //   String reply,
  // ) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? username = prefs.getString('userName');

  //   print(username);
  //   // Get a reference to the post document
  //   DocumentReference postRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('feeds')
  //       .doc(postId);

  //   // Get the current data of the post
  //   DocumentSnapshot postDoc = await postRef.get();
  //   if (postDoc.exists) {
  //     print("trueeeeeeeeee");
  //     var data = postDoc.data() as Map<String, dynamic>;
  //     List<dynamic> comments = data['comments'] ?? [];

  //     // Find the parent comment in the comments list
  //     var parentComment = comments.firstWhere(
  //       (comment) => comment['id'] == parentCommentId,
  //       orElse: () => null,
  //     );
  //     if (parentComment != null) {
  //       // Initialize replies list if null
  //       parentComment['replies'] ??= [];

  //       // Create a new reply object
  //       model.CommentsOnFeed newReply =
  //           model.CommentsOnFeed(name: username, comment: reply);

  //       // Add the new reply to the parent comment's replies list
  //       parentComment['replies'].add(newReply.toJson());

  //       // Update the post document with the updated comments list
  //       await postRef.update({'comments': comments});
  //     }
  //   }
  // }

  void getComments(String userId, String postId) async {
    // Get a reference to the post document
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('feeds')
        .doc(postId);

    // Get the current data of the post
    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      comments.clear();
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> commentsData = data['comments'] ?? [];

      print(
          'Raw Comments Data: $commentsData'); // Debugging: Print raw comments data

      // Convert each comment data to a Comment object and add to the comments list
      commentsData.forEach((commentData) {
        model.CommentsOnFeed comment =
            model.CommentsOnFeed.fromJson(commentData);
        comments.add(comment);
      });

      print(
          'Processed Comments: $comments'); // Debugging: Print processed comments list
    }
  }

  void getFeedList() async {
    if (user != null) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('feeds').get();

      List<model.Feeds> userFeeds = [];
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          model.Feeds feed = model.Feeds(
            postId: data['postId'],
            image: data['image'],
            title: data['title'],
            userUid: data['userUid'],
            ownerName: data['ownerName'],
            timeStamp: data['timeStamp'],
          );
          userFeeds.add(feed);
        }
      });

      feedList.assignAll(userFeeds);
    }
  }

  void navigateToHomeScreen(BuildContext context) {
    Get.to(BottomNavBar());
  }
}
