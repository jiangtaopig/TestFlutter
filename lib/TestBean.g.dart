// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TestBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestBean _$TestBeanFromJson(Map<String, dynamic> json) => TestBean(
      json['name'] as String,
      json['age'] as int,
      (json['contents'] as List<dynamic>)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TestBeanToJson(TestBean instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'contents': instance.contents,
    };

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      json['content'] as String,
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'content': instance.content,
    };
