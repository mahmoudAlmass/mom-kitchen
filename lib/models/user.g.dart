// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userID: json['userID'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isChief: json['isChief'] as bool?,
      backgroungProfileImage: json['backgroungProfileImage'] as String?,
      closingTime: json['closingTime'] as String?,
      openingTime: json['openingTime'] as String?,
      introduction: json['introduction'] as String?,
      location: json['location'] as String?,
      deviceToken: json['deviceToken'] as String?,
      numberOfLoves: json['numberOfLoves'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'isChief': instance.isChief,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'backgroungProfileImage': instance.backgroungProfileImage,
      'introduction': instance.introduction,
      'location': instance.location,
      'deviceToken': instance.deviceToken,
      'numberOfLoves': instance.numberOfLoves,
    };
