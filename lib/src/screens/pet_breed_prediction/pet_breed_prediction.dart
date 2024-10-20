import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/controllers/breedPridiction_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DogBreedPredictionScreen extends StatelessWidget {
  const DogBreedPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BreedPredictionController controller =
        Get.put(BreedPredictionController());
    controller.loadModel();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Pet Breed Identification",
          fontSize: 16.sp,
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 20.h,
                child: controller.image.value.path == ''
                    ? Icon(Icons.camera)
                    : Image.file(File(controller.image.value.path)),
              ),
              SizedBox(height: 2.h),
              if (controller.busy.value)
                Center(child: CircularProgressIndicator()),
              ...controller.recognitions.map((recog) {
                var label = controller.recognitions[0]['label'];
                return CustomText(text: label.toString());
              }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              text: "Select From Gallery",
              voidCallback: () => controller.pickImage(ImageSource.gallery),
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomButton(
              text: "Select From Camera",
              voidCallback: () => controller.pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}
