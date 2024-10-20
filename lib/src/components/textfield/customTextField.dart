import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextFormField extends StatelessWidget {
  final double? width;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool? obsecureText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final Function()? onTapSuffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.obsecureText,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.keyboardType,
    this.onTapSuffixIcon,
    this.validator,
    this.width, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 6.h,
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obsecureText ?? false,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? AppColors.primaryWhite,
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.transparent),
                borderRadius: BorderRadius.circular(12.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.transparent),
                borderRadius: BorderRadius.circular(12.0)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.transparent),
                borderRadius: BorderRadius.circular(12.0)),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onTapSuffixIcon,
                    child: Icon(
                      suffixIcon,
                      color: AppColors.primaryBlack,
                    ),
                  )
                : null,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.primaryBlack,
                  )
                : null,
            labelStyle: const TextStyle(color: AppColors.primaryBlack),
            hintStyle: const TextStyle(color: AppColors.primaryBlack),
            labelText: labelText,
            hintText: hintText),
      ),
    );
  }
}
