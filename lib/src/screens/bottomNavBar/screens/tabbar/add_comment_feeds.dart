import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/add_replies_feeds.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../controllers/feeds_controller.dart';

class AddCommentOnFeeds extends StatelessWidget {
  final String userId;
  final String postId;
  const AddCommentOnFeeds(
      {super.key, required this.userId, required this.postId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final FeedsController controller = Get.put(FeedsController());
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
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightGrey),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Icon(Icons.person),
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
                        height: 5.sp,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRepliesFeeds(
                                      index: index,
                                      postId: postId,
                                      userId: userId)));
                          controller.fetchAndSetReplies(userId, postId, index);
                        },
                        child: CustomText(
                          text: "Replies",
                          fontSize: 15.sp,
                          textColor: AppColors.primaryGrey,
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
                onTap: () {
                  controller.addCommentOnPost(
                      userId, postId, commentController.text);
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
