// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notifications _$NotificationsFromJson(Map<String, dynamic> json) =>
    Notifications(
      imageUrl: json['imageUrl'] as String?,
      notificationContent: json['notificationContent'] as String?,
    );

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'notificationContent': instance.notificationContent,
    };
