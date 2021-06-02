class ActiveFileInfoModel {
  String appId;
  String sdkKey;
  String platform;
  String sdkType;
  String sdkVersion;
  String fileVersion;
  String startTime;
  String endTime;

  ActiveFileInfoModel(
      {this.appId: "",
      this.sdkKey: "",
      this.platform: "",
      this.sdkType: "",
      this.sdkVersion: "",
      this.fileVersion: "",
      this.startTime: "",
      this.endTime: ""});

  factory ActiveFileInfoModel.fromJson(Map<String, dynamic> json) =>
      ActiveFileInfoModel(
        appId: json["appId"] == null ? "" : json["appId"],
        sdkKey: json["sdkKey"] == null ? "" : json["sdkKey"],
        platform: json["platform"] == null ? "" : json["platform"],
        sdkType: json["sdkType"] == null ? "" : json["sdkType"],
        sdkVersion: json["sdkVersion"] == null ? "" : json["sdkVersion"],
        fileVersion: json["fileVersion"] == null ? "" : json["fileVersion"],
        startTime: json["startTime"] == null ? "" : json["startTime"],
        endTime: json["endTime"] == null ? "" : json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "sdkKey": sdkKey,
        "platform": platform,
        "sdkType": sdkType,
        "sdkVersion": sdkVersion,
        "fileVersion": fileVersion,
        "startTime": startTime,
        "endTime": endTime,
      };
}
