class CrashBean {
  String taskId = "005";
  String errMsg = "";

  CrashBean({required this.errMsg});

  void setTaskId(String id) {
    taskId = id;
  }

  void setErrorMsg(String errorMsg) {
    this.errMsg = errorMsg;
  }

  String getTaskId() {
    return taskId;
  }

  String getErrorMsg() => errMsg;

  factory CrashBean.fromJson(Map<String, dynamic> parsedJson) {
    return CrashBean(
      // taskId: parsedJson ['taskId'],
      errMsg: parsedJson['errMsg'],
    );
  }

  Map toJson() {
    Map map = new Map();
    map["taskId"] = this.taskId;
    map["errMsg"] = this.errMsg;
    return map;
  }
}
