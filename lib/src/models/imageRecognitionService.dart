import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

const String mobile = "MobileNet";
const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";
const String deeplab = "DeepLab";
const String posenet = "PoseNet";

class ImageRecognitionService {
  Future<void> loadModel(String model) async {
    Tflite.close();
    try {
      String res;
      switch (model) {
        case yolo:
          res = (await Tflite.loadModel(
            model: "assets/images/yolov2_tiny.tflite",
            labels: "assets/images/yolov2_tiny.txt",
          ))!;
          break;
        case ssd:
          res = (await Tflite.loadModel(
            model: "assets/images/ssd_mobilenet.tflite",
            labels: "assets/images/ssd_mobilenet.txt",
          ))!;
          break;
        case deeplab:
          res = (await Tflite.loadModel(
            model: "assets/images/deeplabv3_257_mv_gpu.tflite",
            labels: "assets/images/deeplabv3_257_mv_gpu.txt",
            // useGpuDelegate: true,
          ))!;
          break;
        case posenet:
          res = (await Tflite.loadModel(
            model:
                "assets/images/posenet_mv1_075_float_from_checkpoints.tflite",
            // useGpuDelegate: true,
          ))!;
          break;
        default:
          res = (await Tflite.loadModel(
            model: "assets/images/mobilenet_v1_1.0_224.tflite",
            labels: "assets/images/mobilenet_v1_1.0_224.txt",
          ))!;
      }
      print("Model loaded: $res");
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future<List?> recognizeImage(String model, String path) async {
    switch (model) {
      case yolo:
        return await yolov2Tiny(path);
      case ssd:
        return await ssdMobileNet(path);
      // Add cases for other models as needed
      default:
        return await recognizeDefaultModel(path);
    }
  }

  Future<List?> yolov2Tiny(String path) async {
    return await Tflite.detectObjectOnImage(
      path: path,
      model: "YOLO",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 1,
    );
  }

  Future<List?> ssdMobileNet(String path) async {
    return await Tflite.detectObjectOnImage(
      path: path,
      numResultsPerClass: 1,
    );
  }

  Future<List?> recognizeDefaultModel(String path) async {
    return await Tflite.runModelOnImage(
      path: path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
  }
}
