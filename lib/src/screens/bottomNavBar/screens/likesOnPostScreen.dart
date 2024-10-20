import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/feeds_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LikesOnPostScreen extends StatelessWidget {
  final String userId;
  final String postId;
  const LikesOnPostScreen(
      {super.key, required this.userId, required this.postId});

  @override
  Widget build(BuildContext context) {
    final FeedsController controller = Get.put(FeedsController());
    controller.getLikeCount(userId, postId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: "Likes",
          fontSize: 15.sp,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Obx(
          () => ListView.builder(
              itemCount: controller.likes.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      color: AppColors.gradientBlueColor3,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    CustomText(text: controller.likes[index].name ?? '')
                  ],
                );
              }),
        ),
      ),
    );
  }
}
