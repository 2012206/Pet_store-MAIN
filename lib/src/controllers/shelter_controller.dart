import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;

class ShelterController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  RxList feedList = [].obs;

  addShelter({
    required String name,
    required String email,
    required String contactNo,
    required String address,
    required String postcode,
  }) async {
    final random = Random().nextInt(999999).toString().padLeft(6, '0');

    model.Shelter feed = model.Shelter(
        userUid: user!.uid,
        shelterId: random,
        shelterName: name,
        email: email,
        contactNo: contactNo,
        address: address,
        postCode: postcode);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("shelters")
        .doc(random)
        .set(feed.toJson());
  }

  void getShelterList() async {
    if (user != null) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('shelters').get();

      List<model.Shelter> userFeeds = [];
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          model.Shelter feed = model.Shelter(
            userUid: data['userUid'],
            shelterId: data['shelterId'],
            shelterName: data['shelterName'],
            email: data['email'],
            contactNo: data['contactNo'],
            address: data['address'],
            postCode: data['postCode'],
          );
          userFeeds.add(feed);
        }
      });

      feedList.assignAll(userFeeds);
    }
  }
}
