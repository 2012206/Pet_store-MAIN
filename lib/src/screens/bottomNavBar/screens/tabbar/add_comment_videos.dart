import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/controllers/video_hosting_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCommentOnVideos extends StatelessWidget {
  final String userId;
  final String postId;
  const AddCommentOnVideos({super.key, required this.userId, required this.postId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final VideoHostingController controller = Get.put(VideoHostingController());
    controller.getComments(userId, postId);
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(text: "Comments"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sp),
          child: Obx(
            () => ListView.builder(
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightGrey),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: const Icon(Icons.person),
                              )),
                          SizedBox(
                            width: 2.w,
                          ),
                          CustomText(
                            text: controller.comments[index].name ?? '',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.sp, vertical: 12.sp),
                          child: CustomText(
                              text: controller.comments[index].comment ?? ''),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  );
                }),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 18.sp),
          child: Row(
            children: [
              CustomTextFormField(
                  width: 70.w,
                  hintText: "Add Comment",
                  labelText: "Add Comment",
                  fillColor: AppColors.lightGrey,
                  controller: commentController),
              InkWell(
                onTap: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? username = prefs.getString('userName');
                  print("0p0p0p0p0p0p0p0p0p0p0p0p0p0p");
                  print(username);
                  controller.addCommentOnPost(
                      userId, postId, username??'', commentController.text);
                  commentController.clear();
                  controller.getComments(userId, postId);
                },
                child: Icon(
                  Icons.send,
                  color: AppColors.backgroundBlue,
                  size: 6.h,
                ),
              )
            ],
          ),
        ));
  }
}
