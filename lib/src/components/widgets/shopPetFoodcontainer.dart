import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/smallButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/cartController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShopPetFoodContainer extends StatelessWidget {
  final String image;
  final String productName;
  final String price;
  final String productDescription;
  final String productId;
  const ShopPetFoodContainer(
      {super.key,
      required this.image,
      required this.productName,
      required this.price,
      required this.productDescription, required this.productId});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    return InkWell(
      onTap: () {
        cartController.reset();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.all(16.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        image,
                        width: 15.w,
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: productName,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: price,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            textColor: AppColors.primaryGrey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomText(
                    text: productDescription,
                    fontSize: 16.sp,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            image,
                            width: 8.w,
                            height: 8.h,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          CustomText(
                            text: productName,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                cartController.increment();
                              },
                              icon: const Icon(Icons.add,
                                  color: AppColors.greenColor)),
                          SizedBox(
                            width: 1.w,
                          ),
                          Obx(
                            () => CustomText(
                              text: cartController.product.toString(),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              textColor: AppColors.primaryGrey,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          IconButton(
                              onPressed: () {
                                cartController.decrement();
                              },
                              icon: const Icon(Icons.remove,
                                  color: AppColors.greenColor)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Obx(
                    () => Visibility(
                      visible: cartController.product != 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SmallButton(
                              text: "Rs " +
                                  (cartController.product * int.parse(price))
                                      .toString(),
                              voidCallback: () {}),
                          SmallButton(
                              text: "Add to Cart",
                              voidCallback: () {
                                cartController.addToCart(
                                    productImage: image,
                                    productTitle: productName,
                                    quantity: cartController.product.toString(),
                                    price: price,productId: productId);
                                // Get.snackbar("Success", "Item added to cart",
                                //     backgroundColor:
                                //         Color.fromARGB(255, 206, 202, 202),
                                //     colorText: AppColors.blackColor);
                              })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.textfieldBlue)),
            child: Image.network(
              image,
              width: 15.w,
              height: 15.h,
            ),
          ),
          SizedBox(
            height: 5.sp,
          ),
          CustomText(
            text: productName,
            fontSize: 15.sp,
          ),
          CustomText(
            text: "Rs $price",
            fontSize: 15.sp,
          )
        ],
      ),
    );
  }
}
