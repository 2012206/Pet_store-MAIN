import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/controllers/chat_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/core/app_colors.dart';


class MessageTextfield extends StatefulWidget {
  final String userId;
  const MessageTextfield({super.key, required this.userId});

  @override
  State<MessageTextfield> createState() => _MessageTextfieldState();
}

class _MessageTextfieldState extends State<MessageTextfield> {
  final TextEditingController messageController= TextEditingController();

  final ChatController chatController=Get.find();

  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                boxShadow:
                [
                  const BoxShadow(
                    color:Colors.black,
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ]
            ),
            child: TextField(
              controller: messageController,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your message...',
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.blackColor,
                ),

                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        if(messageController.text.isNotEmpty){
                          await chatController.sendMessage(messageController, widget.userId);
                        }
                      },
                      child: Container(
                          height: 5.5.h,
                          width: 11.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(4.w)
                          ),
                          child:Icon(Icons.send,color: Colors.white,)

                      ),
                    ),
                    SizedBox(width: 3.w),

                  ],
                ),
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.sp),
                    borderSide: BorderSide.none
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }
}
