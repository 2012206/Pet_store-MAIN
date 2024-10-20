import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  final double? width;
  final Color? btnColor;
  final Color? textColor;
  final bool isLoading;
  const CustomButton(
      {super.key,
      required this.text,
      required this.voidCallback,
      this.width,
      this.btnColor, this.textColor,  this.isLoading=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: btnColor ?? AppColors.primaryBlack),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          child: isLoading==false? CustomText(
            text: text,
            textColor:textColor?? AppColors.primaryWhite,
          ):CircularProgressIndicator(color: Colors.white,),
        ),
      ),
    );
  }
}
