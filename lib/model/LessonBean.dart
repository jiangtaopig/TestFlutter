import 'package:json_annotation/json_annotation.dart';
part 'LessonBean.g.dart';

@JsonSerializable()
class LessonBean {

  int status;
  String msg;
  List<LessonDetail> data;

  LessonBean({required this.status, required this.msg, required this.data});

  factory LessonBean.fromJson(Map<String, dynamic> srcJson) => _$LessonBeanFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LessonBeanToJson(this);
}

@JsonSerializable()
class LessonDetail{
  final int id;
  final String name;
  final String picSmall;
  final String picBig;
  final String description;

  LessonDetail({required this.id,
    required this.name,
    required this.picSmall,
    required this.picBig,
    required this.description});

  factory LessonDetail.fromJson(Map<String, dynamic> srcJson) => _$LessonDetailFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LessonDetailToJson(this);

}