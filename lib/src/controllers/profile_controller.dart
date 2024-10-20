import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;

class ProfileController extends GetxController {
  var loggedinUser = model.User().obs;

  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  ///<------------------------------Get Loggedin User Data------------------------------>

  Future<void> getdata() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      loggedinUser.value = model.User.fromSnap(snap);
    }
  }

  ///<------------------------------Update User Data------------------------------>

  Future<String> updateUser({
    required String username,
    required String email,
    required String age,
    required String address,
    required String phoneNumber,
    String? password,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'username': username,
          'email': email,
          'age': age,
          'address': address,
          'phoneNumber': phoneNumber,
        });
        if (password != null && password.isNotEmpty) {
          await user.updatePassword(password);
        }
        await getdata(); // Refresh the local user data
        return "Profile updated successfully";
      } catch (e) {
        return "Error updating profile: $e";
      }
    } else {
      return "No user logged in";
    }
  }
}
