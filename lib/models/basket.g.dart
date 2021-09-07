// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Basket _$BasketFromJson(Map<String, dynamic> json) => Basket(
      basketItemId: json['basketItemId'] as String?,
      chiefId: json['chiefId'] as String?,
      userId: json['userId'] as String?,
      cartItems: (json['cartItems'] as List<dynamic>?)
          ?.map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      basketItemPrice: (json['basketItemPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BasketToJson(Basket instance) => <String, dynamic>{
      'basketItemId': instance.basketItemId,
      'chiefId': instance.chiefId,
      'userId': instance.userId,
      'dateTime': instance.dateTime?.toIso8601String(),
      'cartItems': instance.cartItems?.map((e) => e.toJson()).toList(),
      'basketItemPrice': instance.basketItemPrice,
    };
