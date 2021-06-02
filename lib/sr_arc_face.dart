import 'dart:async';

import 'package:flutter/services.dart';

import 'enum/face_detect_orient_priority_enum.dart';
import 'model/active_file_info_model.dart';
import 'model/version_info_model.dart';

export 'enum/face_detect_orient_priority_enum.dart';
export 'model/active_file_info_model.dart';
export 'model/version_info_model.dart';

class SrArcFace {
  static const MethodChannel _channel = const MethodChannel('sr_arc_face');

  ///TODO: 激活引擎
  ///[appId] appId
  ///[sdkKey] sdkKey
  ///[rootPath] rootPath 人脸识别根目录 特征码存放在 rootPath+"/registed/features/" images 存放在rootPath+"/registed/images/"
  static Future<bool> activeOnLine(String appId, String sdkKey,
      {String? rootPath}) async {
    final bool result = await _channel.invokeMethod('activeOnLine',
        {'appId': appId, 'sdkKey': sdkKey, 'rootPath': rootPath ?? ""});
    return result;
  }

  ///TODO: 获取sdk版本
  static Future<VersionInfoModel> getSdkVersion() async {
    String result = await _channel.invokeMethod('getSdkVersion');
    final resArr = result.split(',');
    VersionInfoModel versionInfo = VersionInfoModel.fromJson(
        {'version': resArr[0], 'buildDate': resArr[1], 'copyRight': resArr[2]});
    return versionInfo;
  }

  /// 设置视频模式检测角度设置
  static Future<void> setFaceDetectDegree(
      FaceDetectOrientPriorityEnum faceDetectOrientPriorityEnum) async {
    int faceDetectOrientPriority = 0;
    switch (faceDetectOrientPriorityEnum) {
      case FaceDetectOrientPriorityEnum.ASF_OP_0_ONLY:
        faceDetectOrientPriority = 1;
        break;
      case FaceDetectOrientPriorityEnum.ASF_OP_90_ONLY:
        faceDetectOrientPriority = 2;
        break;
      case FaceDetectOrientPriorityEnum.ASF_OP_270_ONLY:
        faceDetectOrientPriority = 3;
        break;
      case FaceDetectOrientPriorityEnum.ASF_OP_180_ONLY:
        faceDetectOrientPriority = 4;
        break;
      default:
        break;
    }
    _channel.invokeMethod("setFaceDetectDegree",
        {"faceDetectOrientPriority": faceDetectOrientPriority});
  }

  ///TODO:获取激活文件
  static Future<ActiveFileInfoModel> getActiveFileInfo() async {
    String result = await _channel.invokeMethod('getActiveFileInfo');
    final resArr = result.split(',');
    ActiveFileInfoModel activeFileInfo = ActiveFileInfoModel.fromJson({
      "appId": resArr[0],
      "sdkKey": resArr[1],
      "platform": resArr[2],
      "sdkType": resArr[3],
      "sdkVersion": resArr[4],
      "fileVersion": resArr[5],
      "startTime": resArr[6],
      "endTime": resArr[7],
    });
    return activeFileInfo;
  }
}
