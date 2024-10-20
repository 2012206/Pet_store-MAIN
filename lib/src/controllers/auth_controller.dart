import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;
import 'package:pet_store_app/src/screens/bottomNavBar/bottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<String> signupUser({
    required String email,
    required String username,
    required String age,
    required String address,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      String res = "";
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          phoneNumber.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          age: age,
          address: address,
          mobileno: phoneNumber,
        );
        print(user);

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        await saveUserName(username);
        res = "Account created successfully";
      } else {
        res = "Please enter all fields";
      }
      return res;
    } on FirebaseAuthException catch (e) {
      if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        return "Email is already in use on a different account";
      }
      return "Error creating account: ${e.message}";
    }
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        final userName = await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .get()
            .then((doc) => doc.data()?['username'] ?? '');

        // Save user name to shared preferences
        await saveUserName(userName);
        res = "successfully loggedin";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = "Wrong password entered";
      } else if (e.code == 'user-not-found') {
        res = "User not found\nPlease enter correct email";
      }
      return res;
    }
    return res;
  }

  void navigateToHomeScreen(BuildContext context) {
    Get.to(BottomNavBar());
  }
}
