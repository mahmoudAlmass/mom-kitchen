import 'package:flutter/foundation.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart{
  final String? cartItemId;
  final Meal? cartItemMeal;
  int? cartItemQuantity=0;
  double? cartItemPrice =0;

  Cart({
  this.cartItemId,
  this.cartItemMeal,
  this.cartItemQuantity,
  this.cartItemPrice
});

  Cart copyWith({
      String? cartItemId,
      Meal? cartItemMeal,
      int? cartItemQuantity,
      double? cartItemPrice,
  }) =>
      Cart(
        cartItemId: cartItemId ?? this.cartItemId,
        cartItemMeal: cartItemMeal ?? this.cartItemMeal,
        cartItemQuantity: cartItemQuantity ?? this.cartItemQuantity,
        cartItemPrice: cartItemPrice ?? this.cartItemPrice,
      );


  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}


















class CartItem {
  final String? id;
  final String? mealTitle;
  final int? quantity;
  double? price = 0;
  final String? imageUrl;

  CartItem({
    @required this.id,
    @required this.mealTitle,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
  });
}

class CartItems with ChangeNotifier {
  List<CartItem>? _items = [];

  List<CartItem> get items {
    return this._items!;
  }

  void addMealToOrder(CartItem meal) {
    _items!.add(meal);
    print("in the cart items");
    print(_items!.length);
    notifyListeners();
  }

  bool findMealById(CartItem meal) {
    bool containsMeal = false;
    _items!.forEach((element) {
      if (element.id == meal.id) {
        containsMeal = true;
      }
    });
    return containsMeal;
  }

  CartItem? getMealById(CartItem meal) {
    bool containsMeal = false;
    _items!.forEach((element) {
      if (element.id == meal.id) {
        containsMeal = true;
      }
    });
    if (containsMeal)
      return _items!.firstWhere((element) => element.id == meal.id);
    else
      return null;
  }

  void removeMealFromOrder(String mealId) {
    _items!.removeWhere((element) => element.id == mealId);
    notifyListeners();
  }
}
