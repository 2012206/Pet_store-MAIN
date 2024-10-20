import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/button/smallButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/video_hosting_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class AddVideo extends StatelessWidget {
  const AddVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoHostingController controller = Get.put(VideoHostingController());
    final TextEditingController textController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: CustomText(
          text: "Add New Video",
          fontSize: 16.sp,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.all(12.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: SmallButton(
                      text: "Post",
                      voidCallback: () {
                        if (textController.text != "" ||
                            controller.video.value.path != '') {
                          controller.addVideo(title: textController.text);
                          Navigator.pop(context);
                          // controller.getFeedList();
                          textController.clear();
                          Get.snackbar(
                              "Success", "Video added to your news feed",
                              colorText: AppColors.primaryWhite,
                              backgroundColor: AppColors.lightGreenColor);
                        } else {
                          Get.snackbar(
                              "Invalid Post", "Please add the valid post",
                              colorText: AppColors.primaryWhite,
                              backgroundColor: AppColors.lightGreenColor);
                        }
                      },
                    )),
                TextField(
                  controller: textController,
                  maxLines: controller.video.value.path == '' ? 5 : 1,
                  decoration: InputDecoration(
                    hintText: "What's on your mind",
                    hintStyle: TextStyle(
                        fontSize: 18.sp, color: AppColors.primaryGrey),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.transparent),
                        borderRadius: BorderRadius.circular(12.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.transparent),
                        borderRadius: BorderRadius.circular(12.0)),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.transparent),
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 20.h,
                  child: controller.video.value.path.isEmpty
                      ? Icon(Icons.video_call)
                      : AspectRatio(
                          aspectRatio: controller
                              .videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(controller.videoPlayerController!),
                        ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
                text: "Select Video",
                voidCallback: () {
                  controller.pickVideo();
                }),
          ],
        ),
      ),
    );
  }
}
