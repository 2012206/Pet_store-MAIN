import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;

class CartController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  var product = 0.obs;
  var cartItems = <model.Cart>[].obs;

  increment() {
    product.value++;
  }

  decrement() {
    if (product.value > 0) {
      product.value--;
    }
  }

  void reset() {
    product.value = 0;
  }

  Future<void> addToCart({
    required String productImage,
    required String productTitle,
    required String quantity,
    required String price,
    required String productId,
  }) async {
    try {
      final random = Random().nextInt(999999).toString().padLeft(6, '0');
      model.Cart cartItem = model.Cart(
        userUid: user!.uid,
        cartId: random,
        productImage: productImage,
        productTitle: productTitle,
        quantity: quantity,
        productPrice: price,
        productId: productId,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("Cart")
          .doc(random)
          .set(cartItem.toJson());
      Get.snackbar(
        "Success",
        "Item added to cart",
        backgroundColor: Color.fromARGB(255, 206, 202, 202),
        colorText: AppColors.blackColor,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchCartItems() async {
    try {
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("Cart")
            .get();

        cartItems.clear();
        for (var doc in snapshot.docs) {
          cartItems.add(model.Cart.fromSnap(doc));
        }
         totalAmount;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in cartItems) {
      total += int.parse(item.quantity!) * int.parse(item.productPrice!);
    }
    update();
    refresh();
    return total;
  }

  Future<void> deleteCartItem(String cartId) async {
    try {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("Cart")
            .doc(cartId)
            .delete();
        fetchCartItems();
        Get.snackbar(
          "Success",
          "Item removed from cart",
          backgroundColor: Color.fromARGB(255, 206, 202, 202),
          colorText: AppColors.blackColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
