import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/chat_controller.dart';
import 'package:pet_store_app/src/screens/chat/chat_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/widgets/topHeadingContainer.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  late Stream<QuerySnapshot> conversationQuery;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hello");
    conversationQuery= FirebaseFirestore.instance.collection('userChats').doc(FirebaseAuth.instance.currentUser!.uid).collection("myChats").snapshots();
  readMessage();
  }
  Future<void> readMessage()async{
    print("read message func run");
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      "hasNewMessage":false,
    },SetOptions(merge: true));
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        children: [
          const TopHeadingContainer(text: "MY CHATS"),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:conversationQuery,
              builder: (context, convosnapshot) {
                if(convosnapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(color: AppColors.primaryGreen,));
                }
                else if(convosnapshot.hasError || !convosnapshot.hasData){
                  return SizedBox.shrink();
                }
                else if(convosnapshot.data!.docs.isEmpty){
                  return Center(child: CustomText(text: "No Chats"));
                }
                WidgetsBinding.instance.addPostFrameCallback((va)async{
                  await readMessage();
                });
                dynamic convo=convosnapshot.data!.docs;
                return ListView.builder(
                  itemCount: convo.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context,index) {
                    DocumentSnapshot data = convo[index];
                    Map<String, dynamic> conversation = data.data() as Map<String, dynamic>;
                    return COnversationListTile(conversations: conversation,);
                  }
                );
              }
            ),
          )

        ],
      ),
    );
  }
}

class COnversationListTile extends StatefulWidget {
  final Map<String,dynamic> conversations;
  const COnversationListTile({super.key, required this.conversations});

  @override
  State<COnversationListTile> createState() => _COnversationListTileState();
}

class _COnversationListTileState extends State<COnversationListTile> {
  final ChatController chatController=Get.find();
  late Stream<DocumentSnapshot> userDoc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDoc=FirebaseFirestore.instance.collection('users').doc(widget.conversations['userId']).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: userDoc,
      builder: (context, usersnapshot) {
        if(usersnapshot.connectionState==ConnectionState.waiting){
          return SizedBox.shrink();
        }
        else if(usersnapshot.hasError || !usersnapshot.hasData){
          return SizedBox.shrink();

        }else if(!usersnapshot.data!.exists){
          return GestureDetector(
            onTap: (){
              String userId=widget.conversations['userId'];
              String name= "Deleted Account";
              chatController.convoId.value=widget.conversations['chatId'];
              Get.to(ChatScreenMain(name:name, userId: userId));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: AppColors.primaryGreen,),
                    SizedBox(width: 3.w,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text:"Deleted Account"),
                          LastMessageText(conversations: widget.conversations),
                        ],
                      ),
                    )
                  ],
                ),

                Divider(),
                SizedBox(height:2.h),
              ],
            ),
          );
        }
        dynamic userData=usersnapshot.data!.data();
        return GestureDetector(
          onTap: (){
            String userId=widget.conversations['userId'];
            String name= userData['username'];
            chatController.convoId.value=widget.conversations['chatId'];
            Get.to(ChatScreenMain(name:name, userId: userId));
          },
          child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: AppColors.primaryGreen,),
                      SizedBox(width: 3.w,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: userData['username'].toString()),
                            LastMessageText(conversations: widget.conversations),
                          ],
                        ),
                      )
                    ],
                  ),

                  Divider(),
                  SizedBox(height:2.h),
                ],
               ),
        );
      }
    );
  }
}

class LastMessageText extends StatefulWidget {
  final Map<String,dynamic> conversations;
  
  const LastMessageText({super.key, required this.conversations});

  @override
  State<LastMessageText> createState() => _LastMessageTextState();
}

class _LastMessageTextState extends State<LastMessageText> {
  late Stream<QuerySnapshot> lastMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lastMessage=FirebaseFirestore.instance.collection('messages').doc(widget.conversations['chatId']).collection('chats').orderBy("time",descending: true).snapshots();

  }
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream:lastMessage,
        builder: (context, lastsnapshot) {
          if(lastsnapshot.connectionState==ConnectionState.waiting){
            return SizedBox.shrink();
          }
          else if(lastsnapshot.hasError || !lastsnapshot.hasData){
            return SizedBox.shrink();

          }else if(lastsnapshot.data!.docs.isEmpty){
            return CustomText(text: "No Message Yet");
          }
          dynamic lastmessage=lastsnapshot.data!.docs.first;
          return  Row(
            children: [
              SizedBox(
                  width: 60.w,
                        child: CustomText(text: lastmessage['message'].toString(),fontSize: 17.sp,overflow: TextOverflow.ellipsis,)),
              Spacer(),
              CustomText(text:DateFormat.jm().format(lastmessage['time'].toDate()) ,fontSize: 16.sp,)
            ],
          );


        }
    );
  }
}


