import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/controllers/auth_controller.dart';
import 'package:pet_store_app/src/screens/authentication/login_screen.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final AuthController authController = Get.put(AuthController());

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
                    text: "Create Account",
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
                CustomTextFormField(
                  controller: passwordController,
                  labelText: "Password",
                  hintText: "Password",
                ),
                SizedBox(
                  height: 20.sp,
                ),
                CustomButton(
                  text: "Sign Up",
                  voidCallback: () async {
                    String res = await authController.signupUser(
                      email: emailController.text.trim(),
                      username: nameController.text.trim(),
                      age: ageController.text.trim(),
                      address: addressController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if (res == "Account created successfully") {
                      authController.navigateToHomeScreen(context);
                      Get.snackbar("Account Created Successfully", res,
                          colorText: AppColors.primaryWhite,
                          backgroundColor: AppColors.lightGreenColor);
                    } else {
                      Get.snackbar(
                        res,
                        "Signup failed",
                      );
                    }
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: CustomText(
                        text: "Sign In",
                        textColor: AppColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
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
