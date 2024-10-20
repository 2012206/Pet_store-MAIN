import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/auth_controller.dart';
import 'package:pet_store_app/src/controllers/chat_controller.dart';
import 'package:pet_store_app/src/controllers/feeds_controller.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/likesOnPostScreen.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/add_comment_feeds.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/add_post.dart';
import 'package:pet_store_app/src/screens/chat/chat_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DiscussionScreen extends StatelessWidget {
  // const DiscussionScreen({
  //   Key? key,
  // }) : super(key: key);
  final ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    final FeedsController controller = Get.put(FeedsController());
    final AuthController authController = Get.put(AuthController());
    controller.getFeedList();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "All Feeds"),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPost()));
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
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.feedList.length,
                    itemBuilder: (context, index) {
                      String title = controller.feedList[index].title;
                      String imageUrl = controller.feedList[index].image;
                      String userId = controller.feedList[index].userUid;
                      String postId = controller.feedList[index].postId;
                      String ownerName =
                          controller.feedList[index].ownerName ?? '';

                      return FutureBuilder<String?>(
                        future: authController.getUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // String? userName = snapshot.data;
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
                                    CustomText(text: ownerName),
                                    Spacer(),
                                    if (userId !=
                                        FirebaseAuth.instance.currentUser!.uid)
                                      GestureDetector(
                                          onTap: () async {
                                            await chatController
                                                .getConvoId(userId);
                                            Get.to(ChatScreenMain(
                                              name: ownerName,
                                              userId: userId,
                                            ));
                                          },
                                          child: Icon(Icons.message)),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomText(text: title),
                                imageUrl.isNotEmpty
                                    ? Hero(
                                        tag: imageUrl, // Use a unique tag
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return DetailScreen(
                                                  imageUrl: imageUrl);
                                            }));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 22.h,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 1.h,
                                      ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            int newLikeCount = await controller
                                                .addLikeOnPost(userId, postId);
                                            controller.updateLikeCount(
                                                index, newLikeCount);
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.thumb_up),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              CustomText(
                                                text: "Like",
                                                fontSize: 15.sp,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        // Obx(() => CustomText(
                                        //       text:
                                        //           '${controller.feedList[index].likes} Likes',
                                        //       fontSize: 15.sp,
                                        //       textColor: AppColors.textBlue,
                                        //     )),
                                        FutureBuilder<int>(
                                          future: controller.getLikeCount(
                                              userId, postId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox.shrink();
                                            }
                                            if (snapshot.hasData) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LikesOnPostScreen(
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
                                                  textColor: AppColors.textBlue,
                                                ),
                                              );
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LikesOnPostScreen(
                                                                userId: userId,
                                                                postId:
                                                                    postId)));
                                                controller.getLikesOnPost(
                                                    userId, postId);
                                              },
                                              child: CustomText(
                                                text: '0 Likes',
                                                fontSize: 15.sp,
                                                textColor: AppColors.textBlue,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddCommentOnFeeds(
                                                        userId: userId,
                                                        postId: postId)));
                                        controller.getComments(userId, postId);
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
                                SizedBox(
                                  height: 1.h,
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                const Divider(
                                  thickness: 7,
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  const DetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl, // The same tag used in the previous screen
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
