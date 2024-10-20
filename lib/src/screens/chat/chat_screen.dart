
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/controllers/chat_controller.dart';
import 'package:pet_store_app/src/screens/chat/size_box_ex.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'message_list.dart';
import 'message_text_field.dart';



class ChatScreenMain extends StatefulWidget {
  final String name;
  final String userId;
  const ChatScreenMain({super.key, required this.name, required this.userId,});
  @override
  State<ChatScreenMain> createState() => _ChatScreenMainState();
}

class _ChatScreenMainState extends State<ChatScreenMain> {
  final ChatController chatController=Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding:EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              2.height,
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 6.h,
                      width: 6.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.w),
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                  ),
                  2.width,
                  CircleAvatar(
                    radius: 3.h,
                    // foregroundImage: const AssetImage(AppImages.girl1),
                  ),
                  1.width,
                  Expanded(
                    child: Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ),

                ],
              ),
              2.height,
              Divider(color: Colors.grey,),
              1.height,
              MessagesList(),
              MessageTextfield(userId: widget.userId,),
              2.height,


            ],
          ),
        ),
      ),
    );
  }
}










