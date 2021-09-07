import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/models/cart.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier{
  Cart _cart = Cart();

  Cart get cart => _cart;
  
  void initCart(){
    _cart= Cart(cartItemId: Uuid().v4());
    notifyListeners();
  }
  void setCurrentCart(Cart cart){
    _cart=cart;
    notifyListeners();
  }
  void addMealToCart(Meal meal){
    if(_cart.cartItemMeal==null){
      _cart=_cart.copyWith(
      cartItemMeal: meal,  
      cartItemQuantity:1,
      cartItemPrice: meal.price,
      );
    notifyListeners();
    }else{
      increasCartQuantity();
    }
    
  }
  void increasCartQuantity(){
    _cart=_cart.copyWith(
      cartItemQuantity:_cart.cartItemQuantity!+1,
      cartItemPrice: _cart.cartItemPrice!+_cart.cartItemMeal!.price!
      );
    notifyListeners();
  }
  
  void decreasCartQuantity(){
    if(_cart.cartItemQuantity!>1){
      _cart=_cart.copyWith(
      cartItemQuantity:_cart.cartItemQuantity!-1,
      cartItemPrice: _cart.cartItemPrice!-_cart.cartItemMeal!.price!
      );
    }else{
      _cart=_cart.copyWith(
      cartItemQuantity:0,
      cartItemPrice: 0,
      cartItemMeal: null
      );
    }
    notifyListeners();

  }

}