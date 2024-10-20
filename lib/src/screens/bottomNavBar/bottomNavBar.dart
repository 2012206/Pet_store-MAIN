import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/drawer/drawer.dart';
import 'package:pet_store_app/src/controllers/bottomNavBar_controller.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/cart_screen.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/pet_shelter.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/pet_store.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/pet_community.dart';
import 'package:pet_store_app/src/screens/chat/my_chats.dart';
import 'package:pet_store_app/src/screens/mosque_finder.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final TextStyle unselectedLabelStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  final TextStyle selectedLabelStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: landingPageController.changeTabIndex,
          currentIndex: landingPageController.tabIndex.value,
          backgroundColor: AppColors.lightGreenColor,
          unselectedItemColor: AppColors.primaryWhite,
          selectedItemColor: AppColors.greenColor,
          unselectedLabelStyle: unselectedLabelStyle,
          selectedLabelStyle: selectedLabelStyle,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: const Icon(
                  Icons.home,
                  size: 20.0,
                ),
              ),
              label: 'Home',
              backgroundColor: AppColors.lightGreenColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: const Icon(
                  Icons.group,
                  size: 20.0,
                ),
              ),
              label: 'Community',
              backgroundColor: AppColors.lightGreenColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: const Icon(
                  Icons.pets,
                  size: 20.0,
                ),
              ),
              label: 'Pet Shelter',
              backgroundColor: AppColors.lightGreenColor,
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder<QuerySnapshot>(
      stream: userQuery,
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: 20.0,
                      ),
                    );
                  }else if(snapshot.hasError || !snapshot.hasData){
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: 20.0,
                      ),
                    );

                  }
                  else if(snapshot.data!.docs.isEmpty){
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: 20.0,
                      ),
                    );

                  }
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        child: const Icon(
                          CupertinoIcons.chat_bubble_text_fill,
                          size: 20.0,
                        ),
                      ),
                      CircleAvatar(radius: 5,backgroundColor: Colors.red,)
                    ],
                  );
                }
              ),
              label: 'Chat',
              backgroundColor: AppColors.lightGreenColor,
            ),
          ],
        )));
  }
  late Stream<QuerySnapshot> userQuery;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userQuery= FirebaseFirestore.instance.collection('users').where("uid",isEqualTo:FirebaseAuth.instance.currentUser!.uid).where('hasNewMessage',isEqualTo: true).snapshots();
  }
  final BottomNavBarController landingPageController =
  Get.put(BottomNavBarController(), permanent: false);
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            icon:const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      drawer: const UserDrawer(),
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children:  [
              PetStoreScreen(),
              PetCommunity(),
              // PetShelterScreen(),
              MosqueFinder(),
              if(landingPageController.tabIndex.value==3)
              MyChats(),
            ],
          )),
    ));
  }
}
