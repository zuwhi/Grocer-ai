// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/pages/camera/provider/object_detect.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_notifier.g.dart';


// membuat object yang akan saya jadikan state
class CameraNotifierState {
  String? label; // label adalah nama objectnya nanti 
  num? percen; 
  bool? isCamerainitialized;
  CameraController? cameraController;

  CameraNotifierState({
    this.label,
    this.percen,
    this.isCamerainitialized,
    this.cameraController,
  });
}


@riverpod
class CameraNotifier extends _$CameraNotifier {
  @override
  CameraNotifierState build() => CameraNotifierState(
      label: '',
      percen: 0,
      isCamerainitialized: false,
      cameraController: CameraController(
          const CameraDescription(
              name: '',
              lensDirection: CameraLensDirection.front,
              sensorOrientation: 0),
          ResolutionPreset.max));
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  late CameraImage cameraImage;
  var cameraCount = 0;

  // memulai inisiasi kamera
  Future initCamera() async {
    print('cek 1');

    // meminta perijinan kamera
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      state.cameraController = CameraController(
          cameras[0], ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.yuv420);

      await state.cameraController!.initialize().then((value) {
        state.cameraController!.startImageStream((image) {
          print('cek objct');
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            // objectDetector(image);
            ref.watch(objectDetectProvider.notifier).objectDetector(image);
          }
        });
      });
      state = CameraNotifierState(
          label: '',
          percen: 0,
          isCamerainitialized: true,
          cameraController: state.cameraController);
      print('cek 2');
    } else {
      print("permission denied");
    }
  }


  disposeCam() {
    state.cameraController!.dispose();
  }
}





