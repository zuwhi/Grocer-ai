// import 'package:get/get.dart';
// import 'package:camera/camera.dart';
// import 'package:logger/logger.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';

// class ScanController extends GetxController {
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     initCamera();
//     initTFlite();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     cameraController.dispose();
//   }

//   late CameraController cameraController;
//   late List<CameraDescription> cameras;

//   late CameraImage cameraImage;

//   var isCamerainitialized = false.obs;
//   var cameraCount = 0;

//   var x, y, w, h = 0.0;
//   var label = "";
//   double? presentage;

//   initCamera() async {
//     if (await Permission.camera.request().isGranted) {
//       cameras = await availableCameras();
//       cameraController = CameraController(cameras[0], ResolutionPreset.max,
//           imageFormatGroup: ImageFormatGroup.yuv420);

//       await cameraController.initialize().then((value) {
//         cameraController.startImageStream((image) {
//           cameraCount++;
//           if (cameraCount % 10 == 0) {
//             cameraCount = 0;
//             objectDetector(image);
//           }
//           update();
//         });
//       });
//       isCamerainitialized(true);
//       update();
//     } else {
//       print("permission denied");
//     }
//   }

//   initTFlite() async {
//     await Tflite.loadModel(
//         model: "assets/model.tflite",
//         labels: "assets/labels.txt",
//         isAsset: true,
//         numThreads: 1,
//         useGpuDelegate: false);
//   }

//   objectDetector(CameraImage image) async {
//     var detector = await Tflite.runModelOnFrame(
//         bytesList: image.planes.map((e) => e.bytes).toList(),
//         asynch: true,
//         imageHeight: image.height,
//         imageWidth: image.width,
//         imageStd: 127.5,
//         imageMean: 127.5,
//         numResults: 1,
//         rotation: 90,
//         threshold: 0.4);

//     if (detector != null) {
//       var detectedObject = detector.first;
//       label = detectedObject['label'];
//       presentage = detectedObject['confidence'];
//       Logger().d(presentage);
//       // print("cek in ctrl $detectedObject");
//       // if (detectedObject["confidenceInClass"] * 100 > 45) {
//       //   label = detectedObject['label'].toString();
//       //   print("cek in ctrl $label");
//       //   h = detectedObject['rect']['h'];
//       //   w = detectedObject['rect']['w'];
//       //   x = detectedObject['rect']['x'];
//       //   y = detectedObject['rect']['y'];
//       // }
//       update();
//     }
//   }
// }
