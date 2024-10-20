import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxString convoId = 'None'.obs;
  Future<void> startConvo(String userId) async {
    //create conversation in first user
    await FirebaseFirestore.instance
        .collection('userChats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('myChats')
        .doc(userId)
        .set({
      "userId": userId,
      "chatId": "${FirebaseAuth.instance.currentUser!.uid}_${userId}"
    }, SetOptions(merge: true));

    //create conversation in second user
    await FirebaseFirestore.instance
        .collection('userChats')
        .doc(userId)
        .collection('myChats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "chatId": "${FirebaseAuth.instance.currentUser!.uid}_${userId}"
    }, SetOptions(merge: true));

    convoId.value = "${FirebaseAuth.instance.currentUser!.uid}_${userId}";
    update();
    refresh();
  }

  Future<void> getConvoId(String userId) async {
    try {
      DocumentSnapshot myconvoSnap = await FirebaseFirestore.instance
          .collection('userChats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("myChats")
          .doc(userId)
          .get();
      if (myconvoSnap.exists) {
        dynamic data = myconvoSnap.data();
        convoId.value = data['chatId'];
      } else {
        DocumentSnapshot otherconvoSnap = await FirebaseFirestore.instance
            .collection('userChats')
            .doc(userId)
            .collection("myChats")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (otherconvoSnap.exists) {
          dynamic otherdata = otherconvoSnap.data();
          convoId.value = otherdata['chatId'];
        } else {
          convoId.value = 'None';
        }
      }
    } catch (e) {
    } finally {
      update();
      refresh();
    }
  }

  Future<void> sendMessage(TextEditingController message, String userId) async {
    try {
      if (convoId.value != 'None') {
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(convoId.value)
            .collection('chats')
            .add({
          "message": message.text,
          "time": DateTime.now(),
          "role": FirebaseAuth.instance.currentUser!.uid
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
       "hasNewMessage":true,
        },SetOptions(merge: true));
      }
      else {
        await startConvo(userId)
            .then((val) async => sendMessage(message, userId));
      }

    } catch (e) {}finally{
      message.clear();
      update();
      refresh();
    }
  }



  final ScrollController scrollController = ScrollController();
  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

}
