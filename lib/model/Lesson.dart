class Lesson {
  int status;
  String msg;
  List<LessonWarp> data;

  Lesson({required this.status, required this.msg, required this.data});

  factory Lesson.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<LessonWarp> lessons = list.map((i) => LessonWarp.fromJson(i)).toList();
    return Lesson(
        status: parsedJson['status'],
        msg: parsedJson['msg'],
        data: lessons
    );
  }

}

/// id : 1
/// name : Tony老师聊shell——环境变量配置文件
/// picSmall : http://img.mukewang.com/55237dcc0001128c06000338-300-170.jpg
/// picBig : http://img.mukewang.com/55237dcc0001128c06000338.jpg
/// description : 为你带来shell中的环境变量配置文件
/// learner : 12312
class LessonWarp {
  final int id;
  final String name;
  final String picSmall;
  final String picBig;
  final String description;

  LessonWarp({required this.id,
    required this.name,
    required this.picSmall,
    required this.picBig,
    required this.description});

  factory LessonWarp.fromJson(Map<String, dynamic> parsedJson){
    return LessonWarp(
      id: parsedJson ['id'],
      name: parsedJson['name'],
      picSmall: parsedJson['picSmall'],
      picBig: parsedJson ['picBig'],
      description: parsedJson ['description'],
    );
  }


}
