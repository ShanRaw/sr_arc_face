import 'package:flutter/material.dart';

import 'package:sr_arc_face/arcFace_camera_view.dart';
import 'package:sr_arc_face/sr_arc_face.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ArcFaceController arcFaceController = ArcFaceController();
  bool isActive = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  onCreated() {
    arcFaceController.faceDetectStreamListen((data) {
      print('------------res------------');
      print(data);
      print('------------res------------');
      setState(() {
        userName = data;
      });
    });
  }

  init() async {
    try {
      bool result = await SrArcFace.activeOnLine('', '', rootPath: '');
      print(result);
      if (result)
        setState(() {
          isActive = result;
        });
    } catch (e) {
      print(e);
    }

    ///获取激活文件信息
    final activeInfo = await SrArcFace.getActiveFileInfo();
    print(activeInfo.toJson());

    ///获取版本信息
    final versionInfo = await SrArcFace.getSdkVersion();
    print(versionInfo.toJson());
    //设置视频检测角度
    SrArcFace.setFaceDetectDegree(FaceDetectOrientPriorityEnum.ASF_OP_ALL_OUT);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 500,
                height: 500,
                child: isActive
                    ? ArcFaceCameraView(
                        controller: arcFaceController,
                        showRectView: true,
                        similarity: 0.75,
                        livingDetect: true,
                        maxDetectNum: 10,
                        onCreated: onCreated,
                      )
                    : Container(),
              ),
              TextButton(
                onPressed: () {
                  if (!arcFaceController.isCreate) {
                    return print('未创建');
                  }
                  //root 默认为getExternalStorageDirectory + /arcFace
                  print('请把人脸图片.jpg放入传入的 rootPath + "/registed/images/" 文件夹中');
                  print('默认为 rootPath +"/arcFace/registed/images/"');
                  arcFaceController.register();
                },
                child: Text('注册人脸'),
              ),
              Text(userName)
            ],
          ),
        ),
      ),
    );
  }
}
