import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/components/widgets/topHeadingContainer.dart';
import 'package:pet_store_app/src/controllers/auth_controller.dart';
import 'package:pet_store_app/src/controllers/shelter_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PetShelterScreen extends StatelessWidget {
  const PetShelterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShelterController controller = Get.put(ShelterController());
    final AuthController authController = Get.put(AuthController());
    TextEditingController searchController = TextEditingController();
    controller.getShelterList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        children: [
          const TopHeadingContainer(text: "SHELTER AND HOSPITALS DETAILS"),
          SizedBox(
            height: 2.h,
          ),
          CustomTextFormField(
              hintText: "Search",
              labelText: "Search",
              suffixIcon: Icons.search,
              fillColor: AppColors.lightGrey,
              controller: searchController),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.feedList.length,
                itemBuilder: (context, index) {
                  String shelterName = controller.feedList[index].shelterName;
                  String address = controller.feedList[index].address;
                  String contactNo = controller.feedList[index].contactNo;
                  // String email = controller.feedList[index].email;

                  return FutureBuilder<String?>(
                    future: authController.getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // String? userName = snapshot.data;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.sp),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(14.0)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 10.sp),
                              child: Column(
                                children: [
                                  CustomText(
                                    text: shelterName,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: AppColors.primaryWhite,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  CustomText(
                                    text: "Contact No: $contactNo",
                                    textColor: AppColors.primaryWhite,
                                    fontSize: 16.sp,
                                  ),
                                  CustomText(
                                    text: "Address: $address",
                                    textColor: AppColors.primaryWhite,
                                    fontSize: 16.sp,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
