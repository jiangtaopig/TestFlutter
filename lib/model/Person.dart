import 'package:json_annotation/json_annotation.dart';

part 'Person.g.dart';

@JsonSerializable(explicitToJson : true)
class Person {
  String name;
  int age;
  Address2 address;

  Person(this.name, this.age, this.address);

  // 固定写法 _$类名FromJson
  factory Person.fromJson(Map<String, dynamic> srcJson) => _$PersonFromJson(srcJson);

  // 固定写法 _$类名ToJson
  Map<String, dynamic> toJson() => _$PersonToJson(this);


}

@JsonSerializable(explicitToJson :true)
class Address2 {
  String detailAddress;

  Address2(this.detailAddress);

  // 固定写法 _$类名FromJson
  factory Address2.fromJson(Map<String, dynamic> srcJson) => _$Address2FromJson(srcJson);

  // 固定写法 _$类名ToJson
  Map<String, dynamic> toJson() => _$Address2ToJson(this);
}