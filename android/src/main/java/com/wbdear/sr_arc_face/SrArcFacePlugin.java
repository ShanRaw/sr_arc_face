package com.wbdear.sr_arc_face;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * SrArcFacePlugin
 */
public class SrArcFacePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private FaceMethodCall faceMethodCall;

    private static final String FACE_DETECT_CAMERA_VIEW_CHANNEL = "face_detect_camera_view";

    private FlutterPluginBinding flutterPluginBinding;


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sr_arc_face");
        channel.setMethodCallHandler(this);
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "activeOnLine": // 引擎注册
                String appId = call.argument("appId");
                String sdkKey = call.argument("sdkKey");
                String rootPath = call.argument("rootPath");
                faceMethodCall.handlerActiveOnline(appId, sdkKey, rootPath, result);
                break;
            case "getActiveFileInfo": // 获取激活文件
                faceMethodCall.handlerGetActiveFileInfo(result);
                break;
            case "getSdkVersion": // 获取sdk版本
                faceMethodCall.handlerGetSdkVersion(result);
                break;
            case "setFaceDetectDegree": //设置视频模式检测角度
                int faceDetectOrientPriority = (int) call.argument("faceDetectOrientPriority");
                faceMethodCall.handlerSetFaceDetectOrientPriority(faceDetectOrientPriority, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        faceMethodCall = new FaceMethodCall(binding.getActivity());
        flutterPluginBinding.getPlatformViewRegistry()
                .registerViewFactory(FACE_DETECT_CAMERA_VIEW_CHANNEL, new FaceDetectCameraFactory(
                        binding.getActivity(),
                        flutterPluginBinding.getBinaryMessenger()
                ));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
