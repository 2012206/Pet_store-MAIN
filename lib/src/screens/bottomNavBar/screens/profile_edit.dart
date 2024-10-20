import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/controllers/profile_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    // Pre-fill the controllers with the user data
    nameController.text = profileController.loggedinUser.value.username ?? '';
    emailController.text = profileController.loggedinUser.value.email ?? '';
    ageController.text = profileController.loggedinUser.value.age ?? '';
    addressController.text =
        profileController.loggedinUser.value.address ?? '';
    phoneController.text =
        profileController.loggedinUser.value.mobileno ?? '';
  
    return Scaffold(
      backgroundColor: AppColors.lightGreenColor,
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: "Edit Your Information",
          fontSize: 16.sp,
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.sp,
                ),
                CustomTextFormField(
                  controller: nameController,
                  labelText: "Full Name",
                  hintText: "Full Name",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomTextFormField(
                  controller: emailController,
                  hintText: "Email",
                  labelText: "Email",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomTextFormField(
                  controller: ageController,
                  labelText: "Age",
                  hintText: "Age",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomTextFormField(
                  controller: addressController,
                  labelText: "Address",
                  hintText: "Address",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomTextFormField(
                  controller: phoneController,
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomButton(
                  text: "Update",
                  voidCallback: () async {
                    String res = await profileController.updateUser(
                      username: nameController.text.trim(),
                      email: emailController.text.trim(),
                      age: ageController.text.trim(),
                      address: addressController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                    );
                    Get.snackbar("Success", res,
                        colorText: AppColors.primaryWhite,
                        backgroundColor: AppColors.lightGreenColor);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
