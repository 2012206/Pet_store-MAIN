import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxlines;
  final TextDecoration? underline;
  const CustomText(
      {super.key,
      required this.text,
      this.textColor,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.overflow,
      this.maxlines,
      this.underline});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaler: const TextScaler.linear(1.0),
      style: TextStyle(
          fontFamily: 'SafeGoogleFont',
          decoration: underline,
          decorationColor: AppColors.textBlue,
          fontWeight: fontWeight ?? FontWeight.normal,
          overflow: overflow,
          letterSpacing: -0.48,
          color: textColor ?? Colors.black,
          fontSize: fontSize ?? 18.sp),
    );
  }
}
