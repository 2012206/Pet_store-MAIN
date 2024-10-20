import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/video_hosting_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LikesOnVideoScreen extends StatelessWidget {
  final String userId;
  final String postId;
  const LikesOnVideoScreen(
      {super.key, required this.userId, required this.postId});

  @override
  Widget build(BuildContext context) {
    final VideoHostingController controller = Get.put(VideoHostingController());
    controller.getLikesOnPost(userId, postId);
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: controller.likes[index].name ?? '')
                  ],
                );
              }),
        ),
      ),
    );
  }
}
