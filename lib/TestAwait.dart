class TestAwait {
  Future<String> _test1() async {
    return Future.delayed(Duration(seconds: 3), () {
      return 'i am delay 3s';
    });
  }

  Future test2() async {
    print('test2 start ${new DateTime.now()}');
    String data = await _test1();
    print('test2 test1 end ${new DateTime.now()} , data = ${data}');
    String res = await _test4(data);
    print('test2 test4 end ${new DateTime.now()} , res = ${res}');
  }

  Future<String> _test4(String data) async {
    String res = data + ", hhh";
    return Future.delayed(Duration(seconds: 2), () {
      return res;
    });
  }

  Future<String> wrapData() {
    return _test1().then((value) {
      return _test4(value);
    }).then((value) {
      return value + "-------";
    });
  }

  Future<void> test5() async {
    print("test5 === start ${new DateTime.now()}");
    String v = await wrapData();
    print("test5 === $v , end ${new DateTime.now()}");
  }
}
