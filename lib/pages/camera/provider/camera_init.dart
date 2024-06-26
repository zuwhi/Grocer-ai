import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_item.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/camera/provider/camera_notifier.dart';
import 'package:green_cart_scanner/pages/camera/provider/object_detect.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';

part 'camera_init.g.dart';

@riverpod
class CameraInit extends _$CameraInit {
  @override
  void build() {
    ref.watch(cameraNotifierProvider.notifier).initCamera();
    ref.watch(objectDetectProvider.notifier).initTFlite();
  }
}
