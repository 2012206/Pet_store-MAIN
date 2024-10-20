import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_assets.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/auth_controller.dart';
import 'package:pet_store_app/src/controllers/video_hosting_controller.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/likesOnVideoScreen.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/add_comment_videos.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/add_video.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/playVideo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final VideoHostingController controller = Get.put(VideoHostingController());
    final AuthController authController = Get.put(AuthController());
    controller.getVideoFeedList();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "All Videos"),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddVideo()));
                  },
                  child: Container(
                    width: 10.w,
                    height: 5.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.lightGrey),
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 60.h,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.feedList.length,
                  itemBuilder: (context, index) {
                    String title = controller.feedList[index].title;
                    String video = controller.feedList[index].video;
                    String thumbnail = controller.feedList[index].thumbnail;
                    String userId = controller.feedList[index].userUid;
                    String postId = controller.feedList[index].postId;

                    return FutureBuilder<String?>(
                      future: authController.getUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // String? userName = snapshot.data;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PlayVideo(
                                                  videoUrl: video,
                                                  title: title,
                                                )));
                                  },
                                  child: thumbnail.isNotEmpty
                                      ? SizedBox(
                                          height: 12.h,
                                          width: 45.w,
                                          child: Image.network(
                                            thumbnail,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.asset(
                                            AppAssets.petStore,
                                            width: 45.w,
                                          ),
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
                                        text: title,
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
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.addLikeOnPost(
                                                    userId, postId);
                                              },
                                              child: const Icon(Icons.thumb_up),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            FutureBuilder<int>(
                                              future: controller.getLikeCount(
                                                  userId, postId),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                if (snapshot.hasData) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LikesOnVideoScreen(
                                                                      userId:
                                                                          userId,
                                                                      postId:
                                                                          postId)));
                                                      controller.getLikesOnPost(
                                                          userId, postId);
                                                    },
                                                    child: CustomText(
                                                      text:
                                                          '${snapshot.data} Likes',
                                                      fontSize: 15.sp,
                                                      textColor:
                                                          AppColors.textBlue,
                                                    ),
                                                  );
                                                }
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LikesOnVideoScreen(
                                                                    userId:
                                                                        userId,
                                                                    postId:
                                                                        postId)));
                                                    controller.getLikesOnPost(
                                                        userId, postId);
                                                  },
                                                  child: CustomText(
                                                    text: '0 Likes',
                                                    fontSize: 15.sp,
                                                    textColor:
                                                        AppColors.textBlue,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCommentOnVideos(
                                                            userId: userId,
                                                            postId: postId)));
                                            controller.getComments(
                                                userId, postId);
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.comment),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              CustomText(
                                                text: "Comment",
                                                fontSize: 15.sp,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
