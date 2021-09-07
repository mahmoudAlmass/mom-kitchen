import 'package:flutter/material.dart';
import 'cart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basket.g.dart';

@JsonSerializable(explicitToJson: true)
class Basket{
  String? basketItemId;
  String? chiefId;
  String? userId;
  DateTime? dateTime;
  List<Cart>? cartItems=[];
  double? basketItemPrice = 0;

  Basket({
    this.basketItemId,
    this.chiefId,
    this.userId,
    this.cartItems,
    this.dateTime,
    this.basketItemPrice,
  });

    Basket copyWith({
      final String? basketItemId,
      final String? chiefId,
      final String? userId,
      final List<Cart>? cartItems,
      final DateTime? dateTime,
      double? basketItemPrice 
  }) =>
      Basket(
        basketItemId: basketItemId ?? this.basketItemId,
        chiefId: chiefId ?? this.chiefId,
        userId: userId??this.userId,
        dateTime: dateTime ?? this.dateTime,
        cartItems: cartItems?? this.cartItems,
        basketItemPrice: basketItemPrice ?? this.basketItemPrice,
      );
  

  factory Basket.fromJson(Map<String, dynamic> json) => _$BasketFromJson(json);

  Map<String, dynamic> toJson() => _$BasketToJson(this);
}





















