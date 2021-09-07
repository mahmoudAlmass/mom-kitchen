import 'package:kitchen_ware_project/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable(explicitToJson: true)
class Meal {
  final String? id;
  final String? title;
  final String? chefId;
  final String? imageUrl;
  final int? duration;
  final double? price;
  final String? description;
  final double? rate;
  final int? raterNumber;
  final Map<String,String>? cats;

  Meal(
      {
      this.chefId,
      this.title,
      this.id,
      this.imageUrl,
      this.duration,
      this.price,
      this.description,
      this.rate,
      this.cats,
      this.raterNumber
    });
  
    Meal copyWith({
      String? id,
      String? title,
      String? chefId,
      String? imageUrl,
      int? duration,
      double? price,
      String? description,
      double? rate,
      int? raterNumber,
      Map<String,String>? cats,
  }) =>
      Meal(
        id: id ?? this.id,
        title: title ?? this.title,
        chefId: chefId ?? this.chefId,
        imageUrl: imageUrl?? this.imageUrl,
        duration: duration?? this.duration,
        price: price?? this.price,
        description: description?? this.description,
        rate: rate?? this.rate,
        cats: cats??this.cats,
        raterNumber: raterNumber?? this.raterNumber
      );


  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
