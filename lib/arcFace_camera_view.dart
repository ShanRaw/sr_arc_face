import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///[ArcFaceController] 控制器
///[showRectView]是否显示人脸框 默认为true;
///[similarity] 相似度默认0.75
///[livingDetect] 是否进行活体检测 默认为false
///[maxDetectNum] 是否多人检测
///[onCreated] 创建完成回调
class ArcFaceCameraView extends StatelessWidget {
  final ArcFaceController controller;
  final bool? showRectView;
  final double? similarity;
  final bool? livingDetect;
  final int? maxDetectNum;
  final Function onCreated;

  ArcFaceCameraView(
      {required this.controller,
      this.showRectView,
      this.similarity,
      this.livingDetect,
      this.maxDetectNum,
      required this.onCreated});

  onPlatformViewCreated(int id) {
    controller.init(id,
        showRectView: showRectView,
        similarity: similarity,
        livingDetect: livingDetect,
        maxDetectNum: maxDetectNum,
        callback: onCreated);
    controller.isCreate = true;
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'face_detect_camera_view',
      onPlatformViewCreated: onPlatformViewCreated,
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}

class ArcFaceController {
  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;

  bool isCreate = false;

  /// 人脸数据流监听
  void faceDetectStreamListen(dynamic success, {dynamic error}) {
    _eventChannel.receiveBroadcastStream().listen((data) {
      success(data);
    }, onError: error);
  }

  /// 人脸检测引擎初始化
  Future<void> initEngine() async {
    _methodChannel.invokeMethod("initEngine");
  }

  /// 销毁引擎
  Future<void> unInitEngine() async {
    _methodChannel.invokeMethod("unInitEngine");
  }

  void register() {
    _methodChannel.invokeMethod("register");
  }

  init(int id,
      {bool? showRectView,
      double? similarity,
      bool? livingDetect,
      int? maxDetectNum,
      Function? callback}) {
    _methodChannel = MethodChannel("face_detect_camera_view_method_$id");

    _methodChannel.invokeMethod("loadCameraView", {
      'showRectView': showRectView ?? true,
      'similarity': similarity ?? 0.75,
      'livingDetect': livingDetect ?? false,
      'maxDetectNum': maxDetectNum ?? 10,
    });

    ///
    _eventChannel = EventChannel("face_detect_camera_view_event_$id");

    if (callback != null) {
      callback();
    }
  }
}
