import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShelterContainer extends StatelessWidget {
  final String contactNo;
  final String address;
  const ShelterContainer(
      {super.key, required this.contactNo, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(14.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        child: Column(
          children: [
            CustomText(
              text: "ANIMAL HOME SHELTER",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryWhite,
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomText(
              text: "Contact No: $contactNo",
              textColor: AppColors.primaryWhite,
              fontSize: 16.sp,
            ),
            CustomText(
              text: "Address: $address",
              textColor: AppColors.primaryWhite,
              fontSize: 16.sp,
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomButton(
                text: "Contact Now",
                btnColor: AppColors.lightGreenColor,
                voidCallback: () {})
          ],
        ),
      ),
    );
  }
}
