// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      json['name'] as String,
      json['age'] as int,
      Address2.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'address': instance.address.toJson(),
    };

Address2 _$Address2FromJson(Map<String, dynamic> json) => Address2(
      json['detailAddress'] as String,
    );

Map<String, dynamic> _$Address2ToJson(Address2 instance) => <String, dynamic>{
      'detailAddress': instance.detailAddress,
    };
