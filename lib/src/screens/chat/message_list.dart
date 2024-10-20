import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/controllers/chat_controller.dart';
import 'package:pet_store_app/src/screens/chat/size_box_ex.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class MessagesList extends StatefulWidget {
  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final ChatController chatController = Get.find();
  late Stream<QuerySnapshot> messagequery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // messagequery=  FirebaseFirestore.instance.collection('messages').doc(chatController.convoId.value).collection('chats').orderBy("time").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(() {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').doc(
                  chatController.convoId.value).collection('chats').orderBy(
                  "time").snapshots(),
              builder: (context, messagesnapshot) {
                if (messagesnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if (messagesnapshot.hasError || !messagesnapshot.hasData) {
                  return Text('');
                }
                else if (messagesnapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No Messages"),
                  );
                }
                dynamic messages = messagesnapshot.data!.docs;
                chatController.scrollToEnd();

                return ListView.builder(
                    controller: chatController.scrollController,
                    itemCount: messages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot messageSnapshot = messages[index];
                      Map<String, dynamic> message = messageSnapshot
                          .data() as Map<String, dynamic>;
                      final role = message['role'];
                      return role == FirebaseAuth.instance.currentUser!.uid
                          ? CurrentUserMessageContainer(message: message)
                          : OtherUserMessageContainer(message: message,);
                    }

                );
              }
          );
        })

    );
  }
}


// For current user who is sender;
class CurrentUserMessageContainer extends StatelessWidget {
  final Map<String, dynamic> message;

  const CurrentUserMessageContainer({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.w, vertical: 0.8.h),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width / 1.6,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomLeft: Radius.circular(14))
                  ),
                  child: Text(message['message'], style: Theme
                      .of(context)!
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                0.5.height,
                Text(DateFormat.jm().format(message['time'].toDate()), style: Theme
                    .of(context)!
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                    color: Colors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400
                ),),
              ],
            ),
            2.width,
            CircleAvatar(
              radius: 2.5.h,
              // foregroundImage: const AssetImage(AppImages.boy1),
            ),
          ],
        ),
        3.height,
      ],
    );
  }
}


// For current user who is receiving;
class OtherUserMessageContainer extends StatelessWidget {
  final Map<String, dynamic> message;

  const OtherUserMessageContainer({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 2.5.h,
              // foregroundImage: const AssetImage(AppImages.girl1),
            ),
            2.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width / 1.6,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(14))
                  ),
                  child: Text(message['message'], style: Theme
                      .of(context)!
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                0.5.height,
                Text(DateFormat.jm().format(message['time'].toDate()), style: Theme
                    .of(context)!
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                    color: Colors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400
                ),),
              ],
            ),

          ],
        ),
        3.height,
      ],
    );
  }
}
