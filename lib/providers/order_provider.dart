import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitchen_ware_project/models/orders.dart';

class OrderProvider extends ChangeNotifier{
  List<Order> orders = [];
  List<Order> pendingSingleOrders = [];
  List<Order> confirmedSingleOrders = [];

  Future<void>addSingleActiveOrderToUserCollection(Order order,String id,String collection)async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection(collection)
        .doc(order.orderId)
        .set(order.toJson());
  }

  Future<void>uploadSingleOrder({required Order order})async{
    await addSingleActiveOrderToUserCollection(order,order.chiefId!,"requested_orders");
    await addSingleActiveOrderToUserCollection(order,order.userId!,"active_orders");   
  }

  Future<void>uploadMultipleOrders({required List<Order> orders})async{
    for(var order in orders){
      await uploadSingleOrder(order: order);
    }
  }

  Future<List<Order>>fetchActiveOrdersByUserId(String id,String collection)async{
    List<Order>_orders=[];
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection(collection)
        .get().then((snapshots){
          for (var snapshot in snapshots.docs )
          {
            _orders.add(Order.fromJson(snapshot.data()));
          }
        });
        orders=_orders;
        notifyListeners();
        _splitOrders();
    return _orders;
  }


  Future<void>_changeOrderStateOnId(String id,Order order, String state,String collection)async{
    await FirebaseFirestore.instance
    .collection("users")
    .doc(id)
    .collection(collection)
    .doc(order.orderId)
    .update({"orderState":state});
  }
  Future<void>changeOrderState(Order order, String state)async{
    await _changeOrderStateOnId(order.chiefId!,order,state,"requested_orders");
    await _changeOrderStateOnId(order.userId!,order,state,"active_orders");
    localyChangeOrderState(order,state);

  }

  Future<void>_deleteOrderOnId(String id,Order order,String collection,bool isFinished ,bool isUser)async{
    await FirebaseFirestore.instance
    .collection("users")
    .doc(id)
    .collection(collection)
    .doc(order.orderId)
    .delete().then((_)async {
    if(isFinished && isUser){
      //add list of meals to user's history
        CollectionReference history = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("orders_history");
        for(var meal in order.basket!.cartItems!){
          history.doc(meal.cartItemMeal!.id!)
          .set({"meal_ref":meal.cartItemMeal!.id!});
        }
        }
    });
  }

  Future<void>deleteOrder(Order order,bool isFinished)async{
    await _deleteOrderOnId(order.chiefId!, order,"requested_orders", isFinished ,false);
    await _deleteOrderOnId(order.userId!, order,"active_orders", isFinished,true);
    locallyDeleteOrder(order);
  }

// not tested yet it need to cancel the timer after deleting the order

  Future<bool>deleteOrderRequistTimeOut(Order order)async{
    Order _order;
    await FirebaseFirestore.instance
    .collection("users")
    .doc(order.chiefId)
    .collection("active_orders")
    .doc(order.orderId)
    .get().then((snapshot) async{
        _order=Order.fromJson(snapshot.data()!);
        if(_order.orderState.toString().split(".").last=="pending"){
          final last = _order.dateTime!;
          final now = DateTime.now();
          final diff = now.difference(last).inMinutes.round();
          if(diff> 2){
            await deleteOrder(order,false);
            return true;
          }
        }
    });
  return false;
  }
  Order getLocallyOrder(Order order){
    return orders.firstWhere((element) => element.orderId==order.orderId);
  }
  void localyChangeOrderState(Order order, String state){
    OrderState newState=Order().setChangeState(state);
    orders.removeWhere((element) => element.orderId==order.orderId);
    Order _order=order.copyWith(orderState: newState);
    orders.add(_order);
    notifyListeners();

    _splitOrders();
  }

  _splitOrders(){
  pendingSingleOrders = orders
    .where((element) =>
        element.orderState.toString().split(".").last == "pending")
    .toList();
  confirmedSingleOrders = orders
    .where((element) =>
        element.orderState.toString().split(".").last !="pending")
    .toList();
    notifyListeners();
  }

  locallyDeleteOrder(Order _order){
    orders.removeWhere((element) => element.orderId==_order.orderId);
    notifyListeners();
    _splitOrders();
  }
}