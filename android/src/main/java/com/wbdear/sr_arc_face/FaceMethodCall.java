package com.wbdear.sr_arc_face;

import android.app.Activity;
import android.util.Log;

import com.arcsoft.face.ActiveFileInfo;
import com.arcsoft.face.ErrorInfo;
import com.arcsoft.face.FaceEngine;
import com.arcsoft.face.VersionInfo;
import com.arcsoft.face.enums.DetectFaceOrientPriority;
import com.wbdear.sr_arc_face.common.Constants;
import com.wbdear.sr_arc_face.util.ConfigUtil;
import com.wbdear.sr_arc_face.util.FileUtils;

import java.io.File;

import io.flutter.plugin.common.MethodChannel.Result;

public class FaceMethodCall {

    private static final String TAG = "FaceMethodCall";
    private final Activity activity;

    public FaceMethodCall(Activity activity) {
        this.activity = activity;
    }

    /**
     * 执行注册sdk
     *
     * @param appId
     * @param sdkKey
     * @param result
     */
    public void handlerActiveOnline(String appId, String sdkKey, String rootPath, Result result) {
        Log.i(TAG, "context：" + activity + "，appId：" + appId + "，sdkKey：" + sdkKey);
        Constants.ROOT_PATH = rootPath.isEmpty() ? (FileUtils.getSDPath(activity) + "/arcFace") : rootPath;
        String feature = Constants.ROOT_PATH + "/registed/features/";
        String images = Constants.ROOT_PATH + "/registed/images/";
        File featureFolder = new File(feature);
        File featureImages = new File(images);
        if (!featureFolder.exists() && !featureFolder.isDirectory()) {
            int res = FileUtils.createDir(feature);
            System.out.println("创建文件夹" + feature + ':' + res);
        }
        if (!featureImages.exists() && !featureImages.isDirectory()) {
            int res = FileUtils.createDir(images);
            System.out.println("创建文件夹" + images + ':' + res);
        }
        int code = FaceEngine.activeOnline(activity, appId, sdkKey);
        Log.i(TAG, "engine result：" + code);
        if (code == ErrorInfo.MOK || code == ErrorInfo.MERR_ASF_ALREADY_ACTIVATED) {
            result.success(true);
        } else {
            Log.e(TAG, "Face SDK Register Error，ErrorCode： " + code);
            result.error("" + code, "激活失败，错误码：" + code + "请根据错误码查询对应错误", null);
        }
    }

    /**
     * 获取激活文件信息
     *
     * @return
     */
    public void handlerGetActiveFileInfo(Result result) {
        ActiveFileInfo activeFileInfo = new ActiveFileInfo();
        int code = FaceEngine.getActiveFileInfo(activity, activeFileInfo);
        if (code == ErrorInfo.MOK) {
            Log.i(TAG, "获取激活文件信息：" + activeFileInfo.toString());
            result.success(activeFileInfo);
        } else {
            Log.e(TAG, "GetActiveFileInfo failed, code is  : " + code);
            result.error("" + code, "获取激活文件信息失败，错误码：" + code + "请根据错误码查询对应错误", null);
        }
    }

    /**
     * 获取sdk版本
     *
     * @return
     */
    public void handlerGetSdkVersion(Result result) {
        VersionInfo versionInfo = new VersionInfo();
        int code = FaceEngine.getVersion(versionInfo);
        if (code == ErrorInfo.MOK) {
            Log.i(TAG, "获取版本信息：" + versionInfo.toString());
            result.success(versionInfo);
        } else {
            Log.e(TAG, "GetSdkVersion failed, code is  : " + code);
            result.error("" + code, "获取sdk版本信息，错误码：" + code + "请根据错误码查询对应错误", null);
        }
    }

    /// 设置视频人脸检测角度
    public void handlerSetFaceDetectOrientPriority(int faceDetectOrientPriority, Result result) {
        switch (faceDetectOrientPriority) {
            case 1:
                ConfigUtil.setFtOrient(activity, DetectFaceOrientPriority.ASF_OP_0_ONLY);
                break;
            case 2:
                ConfigUtil.setFtOrient(activity, DetectFaceOrientPriority.ASF_OP_90_ONLY);
                break;
            case 3:
                ConfigUtil.setFtOrient(activity, DetectFaceOrientPriority.ASF_OP_270_ONLY);
                break;
            case 4:
                ConfigUtil.setFtOrient(activity, DetectFaceOrientPriority.ASF_OP_180_ONLY);
                break;
            default:
                ConfigUtil.setFtOrient(activity, DetectFaceOrientPriority.ASF_OP_ALL_OUT);
                break;
        }
        result.success(faceDetectOrientPriority);
    }
}
