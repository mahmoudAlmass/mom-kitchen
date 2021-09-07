import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/models/basket.dart';
import 'package:kitchen_ware_project/models/cart.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:uuid/uuid.dart';

class BasketProvider extends ChangeNotifier{

  Map<String,Basket> _baskets={};

  Map<String, Basket> get baskets {
  return {..._baskets};
}
  int get basketsCount {
    return _baskets.length;
  }
  double get totalPrice{
    double price=0;;
    baskets.forEach((key, value) {
      price+=value.basketItemPrice!;
    });
    return price;
  }

  bool shouldRebuildCart(Meal meal){
    
    bool rebuild=true;
    if(_baskets[meal.chefId]!=null){
    _baskets[meal.chefId]!.cartItems!.forEach((element) {
      if(element.cartItemMeal!.id==meal.id)
      rebuild= false;
    });
    }

    return rebuild;
  }
  Cart getCartBymeal(Meal meal){
    if(_baskets[meal.chefId]!=null){
      return _baskets[meal.chefId]!.cartItems!
    .firstWhere(
      (element) => element.cartItemMeal!.id==meal.id
      );
    }else{
      return Cart();
    }
    
  }
  
  void updateBasketCart(Cart cart ,Basket basket){
    int index=_baskets[basket.chiefId]!.cartItems!.indexWhere((element) => element.cartItemId==cart.cartItemId);
    _baskets[basket.chiefId]!.cartItems!.removeWhere((element) => element.cartItemId==cart.cartItemId);
    _baskets[basket.chiefId]!.cartItems!.insert(index,cart);
    _baskets[basket.chiefId]!.basketItemPrice = _baskets[basket.chiefId]!.basketItemPrice! + cart.cartItemMeal!.price!;
    notifyListeners();
  }
void decreaseBasketCart(Cart cart ,Basket basket){
    int index=_baskets[basket.chiefId]!.cartItems!.indexWhere((element) => element.cartItemId==cart.cartItemId);
    _baskets[basket.chiefId]!.cartItems!.removeWhere((element) => element.cartItemId==cart.cartItemId);
    _baskets[basket.chiefId]!.cartItems!.insert(index,cart);
    _baskets[basket.chiefId]!.basketItemPrice = _baskets[basket.chiefId]!.basketItemPrice! - cart.cartItemMeal!.price!;
    notifyListeners();
  }

  void addCartToBasket(String chiefId,Cart cartItem,String userId) {

    if(_baskets.containsKey(chiefId)){
      double price=_baskets[chiefId]!.cartItems!.firstWhere((element) => element.cartItemId==cartItem.cartItemId).cartItemPrice!;
      _baskets[chiefId]!.cartItems!.removeWhere((element) => element.cartItemId==cartItem.cartItemId);
      _baskets[chiefId]!.cartItems!.add(cartItem);
      
      _baskets[chiefId]!.basketItemPrice =  cartItem.cartItemPrice! + _baskets[chiefId]!.basketItemPrice! -price;
      _baskets[chiefId]!.dateTime= DateTime.now();

    }else{
        Basket basket=Basket(chiefId: chiefId,basketItemId: Uuid().v4(),userId: userId);
        basket.cartItems=[];
        basket.cartItems!.add(cartItem);
        basket.dateTime= DateTime.now();
        basket.basketItemPrice=cartItem.cartItemPrice;
        _baskets.putIfAbsent(chiefId, () => basket);
    }
      notifyListeners();
}
  void clearBasketWhereId(String id){
    _baskets.remove(id);
    notifyListeners();
  }

  void clearAllBasket(){
    _baskets.clear();
    notifyListeners();
  }
  void clearCartFromBasket(String chiefId,String cartId){
    double price=_baskets[chiefId]!.cartItems!.firstWhere((element) => element.cartItemId==cartId).cartItemPrice!;
    _baskets[chiefId]!.cartItems!.removeWhere((element) => element.cartItemId==cartId);
    _baskets[chiefId]!.basketItemPrice=_baskets[chiefId]!.basketItemPrice! - price;
    if(_baskets[chiefId]!.cartItems!.isEmpty)
    clearBasketWhereId(chiefId);
    notifyListeners();
  }
}