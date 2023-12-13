class DataSharedInstance {
  // 静态变量
  static final DataSharedInstance _singleton = DataSharedInstance._internal();

  // 工厂方法
  factory DataSharedInstance() {
    return _singleton;
  }

  // 私有构造函数
  DataSharedInstance._internal();

  String getMyData() {
    return "oppo_cn_123456";
  }
}
