import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TopHeadingContainer extends StatelessWidget {
  final String text;
  const TopHeadingContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: AppColors.greenColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp),
        child: CustomText(
          text: text,
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryWhite,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
