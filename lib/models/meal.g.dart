// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      chefId: json['chefId'] as String?,
      title: json['title'] as String?,
      id: json['id'] as String?,
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      cats: (json['cats'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      raterNumber: json['raterNumber'] as int?,
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'chefId': instance.chefId,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'price': instance.price,
      'description': instance.description,
      'rate': instance.rate,
      'raterNumber': instance.raterNumber,
      'cats': instance.cats,
    };
