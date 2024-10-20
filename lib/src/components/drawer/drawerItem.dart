import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback voidCallback;
  const DrawerItem({super.key, required this.text, required this.icon, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
      child: InkWell(
        onTap: voidCallback,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(12.0)),
          child: ListTile(
            leading: Icon(icon),
            title: CustomText(text: text),
          ),
        ),
      ),
    );
  }
}
