class VersionInfoModel {
  String version;
  String buildDate;
  String copyRight;

  VersionInfoModel({this.version: "", this.buildDate: "", this.copyRight: ""});

  factory VersionInfoModel.fromJson(Map<String, dynamic> json) =>
      VersionInfoModel(
          version: json["version"] == null ? "" : json["version"],
          buildDate: json["buildDate"] == null ? "" : json["buildDate"],
          copyRight: json["copyRight"] == null ? "" : json["copyRight"]);

  Map<String, dynamic> toJson() =>
      {"version": version, "buildDate": buildDate, "copyRight": copyRight};
}
