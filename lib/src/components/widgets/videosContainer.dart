import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/core/app_assets.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VideosContainer extends StatelessWidget {
  const VideosContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            AppAssets.petStore,
            width: 45.w,
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 45.w,
              child: CustomText(
                text:
                    "Try not to laugh Dogs and cats best funniest animal videos 2023",
                fontSize: 14.sp,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomText(
              text: "456K views",
              fontSize: 14.sp,
            ),
            CustomText(
              text: "1 month ago",
              fontSize: 14.sp,
            ),
          ],
        )
      ],
    );
  }
}
