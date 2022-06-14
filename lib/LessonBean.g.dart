// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LessonBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonBean _$LessonBeanFromJson(Map<String, dynamic> json) => LessonBean(
      status: json['status'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => LessonDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LessonBeanToJson(LessonBean instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data,
    };

LessonDetail _$LessonDetailFromJson(Map<String, dynamic> json) => LessonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      picSmall: json['picSmall'] as String,
      picBig: json['picBig'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$LessonDetailToJson(LessonDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picSmall': instance.picSmall,
      'picBig': instance.picBig,
      'description': instance.description,
    };
