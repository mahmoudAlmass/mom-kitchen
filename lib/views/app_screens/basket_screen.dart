import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/models/orders.dart';
import 'package:kitchen_ware_project/providers/basket_provider.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/widgets/basket_item.dart';
import 'package:kitchen_ware_project/widgets/dashed_line.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:uuid/uuid.dart';

class Basket extends StatefulWidget {
  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final basketProv = Provider.of<BasketProvider>(context, listen: true);
    final baskets = basketProv.baskets;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0.05,
              left: deviceSize.width * 0.03,
              right: deviceSize.width * 0.01,
              bottom: deviceSize.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: LightBlackColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: deviceSize.width * 0.1),
                Text("Your Basket",
                    style: TextStyle(color: LightBlackColor, fontSize: 22)),
              ],
            ),
          ),
          Container(
            height: deviceSize.height * 0.7,
            child: ListView.builder(
              itemCount: baskets.length,
              itemBuilder: (ctx, i) =>
                  BasketItemBuilder(baskets.values.toList()[i]),
            ),
          ),
          const MySeparator(color: Colors.grey),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(fontSize: 24, color: OrangeColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${basketProv.totalPrice}\$",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: RoundedButton(
                  width: deviceSize.width * 0.4,
                  text: 'Order All',
                  press: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                          'Do you want to order all basket?',
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              List<Order> _orders = [];
                              baskets.values.toList().forEach((element) {
                                Order order = Order(
                                    orderId: Uuid().v4(),
                                    chiefId: element.chiefId!,
                                    userId: element.userId!,
                                    basket: element,
                                    dateTime: DateTime.now(),
                                    orderState: OrderState.pending);
                                _orders.add(order);
                              });
                              await Provider.of<OrderProvider>(context,
                                      listen: false)
                                  .uploadMultipleOrders(orders: _orders)
                                  .then((_) async {
                                for (var order in _orders) {
                                  final user = await Provider.of<UserProvider>(
                                          context,
                                          listen: false)
                                      .fetchChiefByid(order.userId!);
                                  final cheif = await Provider.of<UserProvider>(
                                          context,
                                          listen: false)
                                      .fetchChiefByid(order.chiefId!);
                                  // get device token / user name
                                  String token = cheif.deviceToken!;
                                  String userName = user.userName!;
                                  final notHand =
                                      Provider.of<NotificationHandler>(context,
                                          listen: false);
                                  await notHand.sendPushMessage(
                                      token,
                                      "mom's kitchen",
                                      notHand.gettingOrderTemplate(userName)!);
                                }
                                Provider.of<BasketProvider>(context,
                                        listen: false)
                                    .clearAllBasket();
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'you have ordered all your basket',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  color: OrangeColor,
                ),
              ),
            ],
          ),
          SizedBox(height: deviceSize.height * 0.02),
        ],
      ),
    );
  }
}
