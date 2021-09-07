// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      cartItemId: json['cartItemId'] as String?,
      cartItemMeal: json['cartItemMeal'] == null
          ? null
          : Meal.fromJson(json['cartItemMeal'] as Map<String, dynamic>),
      cartItemQuantity: json['cartItemQuantity'] as int?,
      cartItemPrice: (json['cartItemPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'cartItemMeal': instance.cartItemMeal?.toJson(),
      'cartItemQuantity': instance.cartItemQuantity,
      'cartItemPrice': instance.cartItemPrice,
    };
