import 'basket.dart';
import 'package:json_annotation/json_annotation.dart';
part 'orders.g.dart';

@JsonSerializable(explicitToJson: true)
class Order{
  String? orderId ;
  String? chiefId;
  String? userId ;
  Basket? basket;
  OrderState? orderState ;
  DateTime? dateTime;

  Order({
      this.chiefId,
      this.userId,
      this.basket,
      this.orderId,
      this.orderState,
      this.dateTime
      });
  Order copyWith({
  String? orderId ,
  String? chiefId,
  String? userId ,
  Basket? basket,
  OrderState? orderState ,
  DateTime? dateTime,
  }) =>
      Order(
        orderId: orderId ?? this.orderId,
        chiefId: chiefId ?? this.chiefId,
        userId: userId ?? this.userId,
        basket: basket?? this.basket,
        orderState: orderState?? this.orderState,
        dateTime: dateTime?? this.dateTime,
      );
    
  OrderState setChangeState(String state){
    switch(state){
      case 'confirmed': return OrderState.confirmed;
      case 'preparing': return OrderState.preparing;
      case 'ready': return OrderState.ready;
      case 'delevered': return OrderState.delevered;
      default: return OrderState.pending;
    }
  }
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

enum OrderState { pending, confirmed, preparing, ready,delevered }
