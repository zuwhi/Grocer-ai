// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'object_detect.g.dart';

class ObjectState {
  String? label;
  num? percen;
  ObjectState({
    this.label,
    this.percen,
  });
}

@riverpod
class ObjectDetect extends _$ObjectDetect {
  @override
  ObjectState build() => ObjectState(label: '', percen: 0);
  initTFlite() async {
    print('cek 2.5');
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  objectDetector(CameraImage image) async {
    print('cek 3');
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) => e.bytes).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageStd: 127.5,
        imageMean: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4);

    if (detector != null) {
      var detectedObject = detector.first;
      print(detectedObject);

      state = ObjectState(
        label: detectedObject['label'],
        percen: detectedObject['confidence'],
      );
    }
  }
}
