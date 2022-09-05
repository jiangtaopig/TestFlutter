import 'package:json_annotation/json_annotation.dart';

part 'LessonBean.g.dart';

@JsonSerializable()
class LessonBean {
  int status;
  String msg;
  List<LessonDetail> data;

  LessonBean({required this.status, required this.msg, required this.data});

  factory LessonBean.fromJson(Map<String, dynamic> srcJson) =>
      _$LessonBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LessonBeanToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    if (other is LessonBean) {
      return other.runtimeType == this.runtimeType &&
          other.status == this.status &&
          other.msg == this.msg &&
          other.data == this.data;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + status.hashCode;
    result = 37 * result + msg.hashCode;
    result = 37 * result + data.hashCode;
    return result;
  }
}

@JsonSerializable()
class LessonDetail {
  final int id;
  final String name;
  final String picSmall;
  final String picBig;
  final String description;

  LessonDetail(
      {required this.id,
      required this.name,
      required this.picSmall,
      required this.picBig,
      required this.description});

  factory LessonDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$LessonDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LessonDetailToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    } else if (other is LessonDetail) {
      return other.runtimeType == this.runtimeType &&
          other.id == this.id &&
          other.name == this.name &&
          other.picSmall == this.picSmall &&
          other.picBig == this.picBig &&
          other.description == this.description;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + picSmall.hashCode;
    result = 37 * result + picBig.hashCode;
    result = 37 * result + description.hashCode;
    return result;
  }
}
