import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/cartController.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/checkOutScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PetBuyAndSellContainer extends StatelessWidget {
  final String petName;
  final String petImage;
  final String petAge;
  final String petDescription;
  final String petPrice;
  final String docId;
  const PetBuyAndSellContainer(
      {super.key,
      required this.petName,
      required this.petImage,
      required this.petAge,
      required this.petDescription,
      required this.petPrice, required this.docId});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: GestureDetector(
        onTap: () {
          cartController.reset();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.all(16.sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      petImage,
                      height: 40.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomText(
                      text: petName,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: petPrice,
                      fontSize: 16.sp,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomText(
                      text: petDescription,
                      fontSize: 16.sp,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    CustomButton(
                      text: "Adopt Now",
                      voidCallback: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckOutScreen(
                                      price: petPrice,
                                  docId: docId,
                                  petName: petName,
                                  petImage: petImage,petAge: petAge,
                                    )));
                      },
                      btnColor: AppColors.greenColor,
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: Container(
          width: 50.w,
          height: 35.h,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 219, 245, 234),
              borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              Image.network(petImage),
              SizedBox(
                height: 1.h,
              ),
              Container(
                width: 45.w,
                decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sp, vertical: 8.sp),
                      child: Column(
                        children: [
                          CustomText(
                            text: petName,
                            fontSize: 17.sp,
                          ),
                          CustomText(
                            text: "Age: $petAge",
                            fontSize: 15.sp,
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_upward)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
