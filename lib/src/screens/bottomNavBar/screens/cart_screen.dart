import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/controllers/cartController.dart';
import 'package:pet_store_app/src/controllers/order_controller.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;

import 'package:pet_store_app/src/screens/bottomNavBar/screens/checkOutScreen.dart';

import '../../../models/user_model.dart';
import '../../../models/user_model.dart';
import '../../../services/paymentService.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // const CartScreen({super.key});
  RxBool isLoading = false.obs;

final OrderController orderController=Get.find();
  final CartController cartController = Get.put(CartController());

StripeServices stripe =StripeServices();
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Fetch cart items when the screen initializes
    cartController.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Obx(() {
            if (cartController.cartItems.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text('Your cart is empty'),
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final Cart item = cartController.cartItems[index];
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cartController.deleteCartItem(item.cartId!);
                      },
                    ),
                    leading: Image.network(item.productImage ?? ''),
                    title: Text(item.productTitle ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        Row(
                          children: [
                            Text('Price: Rs '),
                            Text((int.parse(item.quantity!) *
                                int.parse(item.productPrice!))
                                .toString()),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
          GetBuilder<CartController>(
              builder: (cartController) {
                return Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                          text: 'Total Amount: Rs ${cartController.totalAmount}',
                          btnColor: AppColors.primaryWhite,
                          textColor: AppColors.greenColor,
                          voidCallback: () {}),
                      Obx(() {
                        return CustomButton(
                            text: "Buy Now",
                            isLoading: isLoading.value,
                            voidCallback: () async {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => CheckOutScreen(
                              //               price: cartController.totalAmount.toString(),
                              //             )));

                              try {
                                print("cart controller ${cartController.cartItems}");
                                if (cartController.cartItems.isNotEmpty) {
                                  isLoading.value = true;
                                  await stripe.payment(
                                      cartController.totalAmount.toString()).then((val)async{      // Process orders after successful payment
                                    for (model.Cart cartItem in cartController.cartItems) {
                                      await orderController.storeorderdata(
                                          cartItem.productPrice.toString(),
                                          cartItem.productId.toString(),
                                          cartItem.productTitle.toString(),
                                          cartItem.quantity.toString(),
                                          cartItem.productImage.toString(),
                                          '',
                                          '',
                                          '',
                                          'petfood',
                                        ''
                                      );
                                    }});

                                }
                                isLoading.value = false;

                              } catch (e) {
                                isLoading.value = false;
                              }finally{
                                isLoading.value = false;

                              }
                            });
                      }),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
