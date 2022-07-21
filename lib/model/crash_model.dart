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

  /// 对象转换为 json 串时需要，否则报错;
  /// 你不需要调用 toJson() 方法，因为 jsonEncode() 已经帮你做了这件事。
  Map toJson() {
    Map map = new Map();
    map["taskId"] = this.taskId;
    map["errMsg"] = this.errMsg;
    return map;
  }
}
