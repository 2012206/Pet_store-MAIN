import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/controllers/feeds_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddRepliesFeeds extends StatelessWidget {
  final int index;
  final String postId;
  final String userId;
  const AddRepliesFeeds(
      {super.key,
      required this.index,
      required this.postId,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final FeedsController controller = Get.put(FeedsController());
    controller.fetchAndSetReplies(userId, postId, index);
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(text: "Replies"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sp),
          child: Obx(
            () => ListView.builder(
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  if (controller.replyOnCommentFeed.isEmpty ||
                      index >= controller.replyOnCommentFeed.length) {
                    return const CustomText(
                        text:
                            "No reply"); // or any other widget to display when no replies are available
                  }
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
                            text:
                                controller.replyOnCommentFeed[index].name ?? '',
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
                              text:
                                  controller.replyOnCommentFeed[index].reply ??
                                      ''),
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
                  hintText: "Add Replies",
                  labelText: "Add Replies",
                  fillColor: AppColors.lightGrey,
                  controller: commentController),
              InkWell(
                onTap: () {
                  controller.addReplyToComment(
                      userId, postId, index, commentController.text);
                  commentController.clear();
                  controller.fetchAndSetReplies(userId, postId, index);
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
