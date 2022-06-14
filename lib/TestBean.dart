import 'package:json_annotation/json_annotation.dart';

part 'TestBean.g.dart'; // 固定写法： 类名.g.dart
// 记得在根目录下执行 flutter pub run build_runner build 生成 TestBean.g.dart 文件

@JsonSerializable()
class TestBean {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'age')
  int age;

  @JsonKey(name: 'contents')
  List<Content> contents;

  TestBean(this.name,this.age,this.contents,);

  // 固定写法 _$类名FromJson
  factory TestBean.fromJson(Map<String, dynamic> srcJson) => _$TestBeanFromJson(srcJson);

  // 固定写法 _$类名ToJson
  Map<String, dynamic> toJson() => _$TestBeanToJson(this);
}

@JsonSerializable()
class Content {

  @JsonKey(name: 'content')
  String content;

  Content(this.content,);

  factory Content.fromJson(Map<String, dynamic> srcJson) => _$ContentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}