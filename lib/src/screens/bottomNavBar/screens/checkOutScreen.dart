import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/controllers/order_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../services/paymentService.dart';

class CheckOutScreen extends StatefulWidget {
  final String price;
  final String docId;
  final String petName;
  final String petImage;
  final String petAge;

  const CheckOutScreen(
      {super.key, required this.price, required this.docId, required this.petName, required this.petImage, required this.petAge});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  StripeServices stripe = StripeServices();

  final OrderController orderController = Get.find();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryWhite,
          ),
        ),
        title: const CustomText(
          text: "Checkout",
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryWhite,
        ),
        elevation: 0,
        backgroundColor: const Color(0xff6ea7db),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xf9ffffff),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                CustomText(
                  text: "Total Bill: ${widget.price}",
                ),
                SizedBox(
                  height: 1.h,
                ),
                const CustomText(
                  text: "Delivery Address",
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 1.h,
                ),
                CustomTextFormField(
                    hintText: "Address",
                    labelText: "Address",
                    fillColor: const Color.fromARGB(255, 148, 207, 197),
                    controller: addressController),
                SizedBox(
                  height: 1.h,
                ),
                CustomTextFormField(
                    hintText: "Postal Code",
                    labelText: "Postal Code",
                    fillColor: const Color.fromARGB(255, 148, 207, 197),
                    controller: postCodeController),
                SizedBox(
                  height: 1.h,
                ),
                CustomTextFormField(
                    hintText: "Mobile Number",
                    labelText: "Mobile Number",
                    fillColor: const Color.fromARGB(255, 148, 207, 197),
                    controller: mobileNumberController),
                SizedBox(
                  height: 3.h,
                ),
                Obx(() {
                  return CustomButton(
                      isLoading: isLoading.value,
                      text: "Place Order", voidCallback: () async {
                    try {
                      if (isLoading.value == false) {
                        if (addressController.text.isNotEmpty &&
                            postCodeController.text.isNotEmpty &&
                            mobileNumberController.text.isNotEmpty) {
                          isLoading.value = true;
                          await stripe.payment(widget.price.toString()).then((
                              val) async {
                            await orderController.storeorderdata(
                                widget.price.toString(),
                                widget.docId,
                                widget.petName,
                                1.toString(),
                                widget.petImage,
                                addressController.text.trim(),
                                postCodeController.text.trim(),
                                mobileNumberController.text.trim(),
                                'petAdopt',
                                widget.petAge
                            );
                            addressController.clear();
                            postCodeController.clear();
                            mobileNumberController.clear();
                          });

                          isLoading.value = false;
                        } else {
                          Get.snackbar("Missing Data", "Enter all fields");
                        }
                      }
                    } catch (e) {
                      print("error placing pet order $e");
                    } finally {
                      isLoading.value = false;
                    }
                  });
                })

              ],
            ),
          ),
        ),
      ),
    );
  }
}
