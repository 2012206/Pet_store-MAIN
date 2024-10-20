import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoHostingController extends GetxController {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  VideoPlayerController? videoPlayerController;
  final ImagePicker picker = ImagePicker();
  RxList feedList = [].obs;
  RxList<model.CommentsOnVideo> comments = <model.CommentsOnVideo>[].obs;
  RxList<model.LikesOnVideo> likes = <model.LikesOnVideo>[].obs;
  Rx<File> video = File('').obs;

  Future pickVideo() async {
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      if (videoFile == null) {
        return;
      }
      final imageTemp = File(videoFile.path);
      video.value = imageTemp;

      videoPlayerController = VideoPlayerController.file(File(videoFile.path))
        ..initialize().then((value) {
          videoPlayerController!.play();
        });
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<Uint8List?> generateVideoThumbnail(File file) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 320,
        quality: 50);
    return thumbnail!;
  }

  addVideo({required String title}) async {
    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    Reference ref = storage.ref().child('videos/${DateTime.now()}.mp4');
    await ref.putFile(video.value);
    String downloadURL = await ref.getDownloadURL();

    // Generate and upload thumbnail
    Uint8List? thumbnailData = await generateVideoThumbnail(video.value);
    Reference thumbnailRef =
        storage.ref().child('thumbnails/${DateTime.now()}.jpg');
    await thumbnailRef.putData(thumbnailData!);
    String thumbnailURL = await thumbnailRef.getDownloadURL();

    model.Videos feed = model.Videos(
        postId: random,
        video: downloadURL,
        thumbnail: thumbnailURL,
        title: title,
        userUid: user!.uid,
        timeStamp: DateTime.now().toString());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("videos")
        .doc(random)
        .set(feed.toJson());
  }

  void getVideoFeedList() async {
    if (user != null) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('videos').get();

      List<model.Videos> userFeeds = [];
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          model.Videos feed = model.Videos(
            postId: data['postId'],
            video: data['video'],
            thumbnail: data['thumbnail'],
            title: data['title'],
            userUid: data['userUid'],
            timeStamp: data['timeStamp'],
          );
          userFeeds.add(feed);
        }
      });

      feedList.assignAll(userFeeds);
    }
  }

  void addLikeOnPost(String userId, String postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('userName');
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('videos')
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likes = data['likes'] ?? [];

      if (!likes.contains(username)) {
        likes.add(username);
        await postRef.update({'likes': likes});
      }
    }
  }

  Future<void> getLikesOnPost(String userId, String postId) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('videos')
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likesData = data['likes'] ?? [];

      print('Raw Likes Data: $likesData'); // Debugging: Print raw likes data

      // Clear existing likes list and add new likes
      likes.clear();
      likesData.forEach((likeData) {
        model.LikesOnVideo like = model.LikesOnVideo(name: likeData);
        likes.add(like);
      });

      print('Processed Likes: $likes'); // Debugging: Print processed likes list
    }
  }

  Future<int> getLikeCount(String userId, String postId) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('videos')
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likes = data['likes'] ?? [];
      return likes.length;
    }
    return 0;
  }

  void addCommentOnPost(
      String userId, String postId, String userName, String comment) async {
    // Get a reference to the post document
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('videos')
        .doc(postId);

    // Get the current data of the post
    DocumentSnapshot postDoc = await postRef.get();
    if (postDoc.exists) {
      var data = postDoc.data() as Map<String, dynamic>;
      List<dynamic> comments = data['comments'] ?? [];

      // Create a new comment object
      model.CommentsOnVideo newComment =
          model.CommentsOnVideo(name: userName, comment: comment);

      // Convert the comment object to JSON and add it to the list of comments
      comments.add(newComment.toJson());

      // Update the post document with the new comments list
      await postRef.update({'comments': comments});
    }
  }

  void getComments(String userId, String postId) async {
    // Get a reference to the post document
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('videos')
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
        model.CommentsOnVideo comment =
            model.CommentsOnVideo.fromJson(commentData);
        comments.add(comment);
      });

      print(
          'Processed Comments: $comments'); // Debugging: Print processed comments list
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
}
