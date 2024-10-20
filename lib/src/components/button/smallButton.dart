import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  const SmallButton(
      {super.key, required this.text, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
        width: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.backgroundDarkBlue),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: CustomText(
            text: text,
            fontSize: 18.sp,
            textColor: AppColors.primaryWhite,
          ),
        ),
      ),
    );
  }
}

class QuickSelectButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  final Color btnColor;
  final Color textColor;
  const QuickSelectButton(
      {super.key,
      required this.text,
      required this.voidCallback,
      required this.btnColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
        width: 25.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), color: btnColor),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: CustomText(
            text: text,
            fontSize: 18.sp,
            textColor: textColor,
          ),
        ),
      ),
    );
  }
}
