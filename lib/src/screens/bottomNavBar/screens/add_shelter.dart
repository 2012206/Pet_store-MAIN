import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/controllers/shelter_controller.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/bottomNavBar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddShelter extends StatelessWidget {
  const AddShelter({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController contactNoController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController postcodeController = TextEditingController();
    final ShelterController controller = Get.put(ShelterController());

    return Scaffold(
      backgroundColor: AppColors.lightGreenColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Create Shelter",
                    fontWeight: FontWeight.bold,
                    textColor: AppColors.primaryWhite,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(
                  height: 30.sp,
                ),
                CustomTextFormField(
                  controller: nameController,
                  labelText: "Shelter Name",
                  hintText: "Shelter Name",
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
                  controller: contactNoController,
                  labelText: "Contact Number",
                  hintText: "Contact Number",
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
                  controller: postcodeController,
                  labelText: "Post Code",
                  hintText: "Post Code",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomButton(
                  text: "Create Shelter",
                  voidCallback: () async {
                    controller.addShelter(
                        name: nameController.text,
                        email: emailController.text,
                        contactNo: contactNoController.text,
                        address: addressController.text,
                        postcode: postcodeController.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBar()));
                  },
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Already have an account?",
                      textColor: AppColors.primaryWhite,
                      fontSize: 15.sp,
                    ),
                    SizedBox(
                      width: 8.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
