import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/smallButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/drawer/drawerItem.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/profile_controller.dart';
import 'package:pet_store_app/src/screens/authentication/login_screen.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/add_shelter.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/profile_edit.dart';
import 'package:pet_store_app/src/screens/order/my_orders.dart';
import 'package:pet_store_app/src/screens/pet_breed_prediction/pet_breed_prediction.dart';
import 'package:pet_store_app/src/screens/pet_history.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pet_store_app/src/models/user_model.dart' as model;

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Drawer(
      backgroundColor: AppColors.lightGreenColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 24.h,
              ),
              Positioned(
                top: 35,
                left: 24,
                child: Obx(
                  () {
                    model.User? user = profileController.loggedinUser.value;
                    return Container(
                      height: 18.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.greenColor.withOpacity(0.8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: user.username ?? 'No username',
                              textColor: AppColors.primaryWhite,
                            ),
                            CustomText(
                              text: user.email ?? 'No email',
                              textColor: AppColors.primaryWhite,
                              fontWeight: FontWeight.w300,
                            ),
                            CustomText(
                              text: user.mobileno ?? 'No phone number',
                              textColor: AppColors.primaryWhite,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          DrawerItem(
            voidCallback: () {
              Get.to(ProfileEditScreen());
            },
            text: "Profile",
            icon: Icons.person_outline,
          ),
          DrawerItem(
            voidCallback: () {
              Get.to(MyOrders());
            },
            text: "Orders",
            icon: Icons.production_quantity_limits,
          ),

          // DrawerItem(
          //   voidCallback: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => AddShelter()));
          //   },
          //   text: "Add Shelter",
          //   icon: Icons.edit_outlined,
          // ),
          DrawerItem(
            voidCallback: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PetHistory()));
            },
            text: "Pet History",
            icon: Icons.edit_outlined,
          ),
          DrawerItem(
            voidCallback: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DogBreedPredictionScreen()));
            },
            text: "Pet Breed Identifier",
            icon: Icons.pets_sharp,
          ),
          DrawerItem(
            voidCallback: () {
              _alert();
            },
            text: "Logout",
            icon: Icons.logout_outlined,
          ),
        ],
      ),
    );
  }

  _alert() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 200, 230, 225),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 2.h),
                  CustomText(
                    text: 'Are you sure you want to Logout?',
                    fontSize: 16.sp,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QuickSelectButton(
                        text: 'No',
                        btnColor: AppColors.primaryWhite,
                        textColor: AppColors.greenColor,
                        voidCallback: () {
                          Navigator.pop(context);
                        },
                      ),
                      QuickSelectButton(
                          text: 'Yes',
                          btnColor: AppColors.greenColor,
                          textColor: AppColors.primaryWhite,
                          voidCallback: () async{
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          })
                    ],
                  )
                ],
              ));
        });
  }
}
