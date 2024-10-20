import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_store_app/src/models/imageRecognitionService.dart';

class BreedPredictionController extends GetxController {
  Rx<File> image = File('').obs;
  var recognitions = [].obs;
  var busy = false.obs;
  var model = 'deeplab';

  final ImageRecognitionService _imageRecognitionService =
      ImageRecognitionService();

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  Future<void> loadModel() async {
    await _imageRecognitionService.loadModel(model);
  }

  Future pickImage(ImageSource source) async {
    try {
      busy.value = true;
      final imagePick = await ImagePicker().pickImage(source: source);
      if (imagePick == null) {
        return;
      }
      final imageTemp = File(imagePick.path);
      image.value = imageTemp;
      await recognizeImage(imagePick);

      busy.value = false;
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<void> recognizeImage(XFile image) async {
    var results =
        await _imageRecognitionService.recognizeImage(model, image.path);
    recognitions.value = results ?? [];
  }
}
