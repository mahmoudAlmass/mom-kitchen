// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      chiefId: json['chiefId'] as String?,
      userId: json['userId'] as String?,
      basket: json['basket'] == null
          ? null
          : Basket.fromJson(json['basket'] as Map<String, dynamic>),
      orderId: json['orderId'] as String?,
      orderState: _$enumDecodeNullable(_$OrderStateEnumMap, json['orderState']),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'chiefId': instance.chiefId,
      'userId': instance.userId,
      'basket': instance.basket?.toJson(),
      'orderState': _$OrderStateEnumMap[instance.orderState],
      'dateTime': instance.dateTime?.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$OrderStateEnumMap = {
  OrderState.pending: 'pending',
  OrderState.confirmed: 'confirmed',
  OrderState.preparing: 'preparing',
  OrderState.ready: 'ready',
  OrderState.delevered: 'delevered',
};
