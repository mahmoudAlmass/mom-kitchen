import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/orders.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/models/cart.dart';
import 'package:kitchen_ware_project/models/basket.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/basket_provider.dart';
import 'package:kitchen_ware_project/providers/cartProvider.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:uuid/uuid.dart';

class BasketItemBuilder extends StatefulWidget {
  final Basket basketItem;
  

  BasketItemBuilder(this.basketItem);

  @override
  _BasketItemBuilderState createState() => _BasketItemBuilderState();
}

class _BasketItemBuilderState extends State<BasketItemBuilder> {
  bool _isLoading=true;
  bool _isInit=true;
  User cheif=User();
  @override
  void didChangeDependencies()async {
    if(_isInit){
      await Provider.of<UserProvider>(context,listen: false).fetchChiefByid(widget.basketItem.chiefId!).then((value) {
        setState(() {
          cheif=value;
          _isLoading=false;
          _isInit=false;
        });
      });
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return _isLoading==true? ShimmerLoading(): Container(
      padding: EdgeInsets.only(
          right: deviceSize.width * 0.01, left: deviceSize.width * 0.07),
      child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/chef_hat.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                       SizedBox(width: deviceSize.width * 0.01),
                  Text(
                    "Chef ${cheif.userName!}",
                    
                    style: TextStyle(fontSize: 16),
                  ),
                    ],
                  ),
                 
                  Padding(
                    padding: EdgeInsets.only(right: deviceSize.width * 0.01),
                    child: PopupMenuButton<String>(
                      onSelected: (choice) {
                        switch (choice) {
                          case 'Delete':
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                  'Do you want to remove this order from the basket?',
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
                                    onPressed: () {
                                      Navigator.of(ctx).pop(true);
                                      Provider.of<BasketProvider>(context,
                                              listen: false)
                                          .clearBasketWhereId(
                                              widget.basketItem.chiefId!);
                                    },
                                  ),
                                ],
                              ),
                            );
                            break;
                          case 'Order':
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                  'Do you want to order this meals?',
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
                                      Order order = Order(
                                          orderId: Uuid().v4(),
                                          chiefId: widget.basketItem.chiefId!,
                                          userId: widget.basketItem.userId!,
                                          basket: widget.basketItem,
                                          dateTime: DateTime.now(),
                                          orderState: OrderState.pending);
                                      await Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .uploadSingleOrder(
                                        order: order,
                                      )
                                          .then((_) async {
                                        final user =
                                            await Provider.of<UserProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchChiefByid(order.userId!);
                                        final cheif =
                                            await Provider.of<UserProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchChiefByid(order.chiefId!);
                                        // get device token / cheif name
                                        String token = cheif.deviceToken!;
                                        String userName = user.userName!;
                                        final notHand =
                                            Provider.of<NotificationHandler>(
                                                context,
                                                listen: false);
                                        await notHand.sendPushMessage(
                                            token,
                                            "mom's kitchen",
                                            notHand.gettingOrderTemplate(
                                                userName)!);
                                        Provider.of<BasketProvider>(context,
                                                listen: false)
                                            .clearBasketWhereId(
                                                widget.basketItem.chiefId!);

                                        Navigator.of(ctx).pop(true);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Delete', 'Order'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: deviceSize.height * 0.03,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.basketItem.cartItems!.length,
            itemBuilder: (ctx, i) => orderMealWidget(
                cart: widget.basketItem.cartItems![i],
                basket: widget.basketItem),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text("Order price: ${widget.basketItem.basketItemPrice}"),
          ),
          SizedBox(height: 20,),
          Divider()
        ],
      ),
    );
  }
}

class orderMealWidget extends StatefulWidget {
  Cart? cart;
  Basket? basket;
  orderMealWidget({required this.cart, required this.basket});

  @override
  _orderMealWidgetState createState() => _orderMealWidgetState();
}

class _orderMealWidgetState extends State<orderMealWidget> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Dismissible(
      key: ValueKey(widget.cart!.cartItemId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the item from the cart?',
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
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<BasketProvider>(context, listen: false).clearCartFromBasket(
            widget.basket!.chiefId!, widget.cart!.cartItemId!);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: deviceSize.height * 0.03),
        height: deviceSize.height * 0.17,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  widget.cart!.cartItemMeal!.imageUrl!,
                  fit: BoxFit.cover,
                  width: deviceSize.width * 0.3,
                  height: deviceSize.height * 0.15,
                ),
                SizedBox(width: deviceSize.width * 0.02),
                Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cart!.cartItemMeal!.title!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      Text(
                        '\$${widget.cart!.cartItemMeal!.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: OrangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                alignment: Alignment.bottomRight,
                child: ChangeQuantity(
                  cart: widget.cart,
                  basket: widget.basket,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class ChangeQuantity extends StatefulWidget {
  Basket? basket;
  Cart? cart;
  ChangeQuantity({this.cart, this.basket});

  @override
  _ChangeQuantity createState() => _ChangeQuantity(cart: cart, basket: basket);
}

class _ChangeQuantity extends State<ChangeQuantity> {
  Basket? basket;
  Cart? cart;

  _ChangeQuantity({this.cart, this.basket});

  int? _quantity;
  double? _price;

  @override
  void initState() {
    _quantity = cart!.cartItemQuantity!;
    _price = cart!.cartItemPrice!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    final basketPorv = Provider.of<BasketProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$$_price',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: deviceSize.width * 0.001,
        ),
        Container(
            width: deviceSize.width * 0.07,
            height: deviceSize.height * 0.05,
            decoration: BoxDecoration(
                color: GrayColor, borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              child: Icon(
                Icons.remove,
                color: BlackColor,
              ),
              onTap: () {
                if (_quantity == 1) {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text(
                              'Do you want to remove the item from the cart?',
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
                                onPressed: () {
                                  basketPorv.clearCartFromBasket(
                                      basket!.chiefId!, cart!.cartItemId!);
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                            ],
                          ));
                } else {
                  cartProv.setCurrentCart(cart!);
                  cartProv.decreasCartQuantity();
                  basketPorv.decreaseBasketCart(cartProv.cart, basket!);
                  setState(() {
                    cart = cartProv.cart;
                    _price = cartProv.cart.cartItemPrice!;
                    _quantity = cartProv.cart.cartItemQuantity!;
                  });
                }
              },
            )),
        SizedBox(
          width: deviceSize.width * 0.03,
        ),
        Text(
          _quantity.toString(),
          style: TextStyle(fontSize: 20, color: LightBlackColor),
        ),
        SizedBox(
          width: deviceSize.width * 0.03,
        ),
        Container(
            width: deviceSize.width * 0.07,
            height: deviceSize.height * 0.05,
            decoration: BoxDecoration(
                color: OrangeColor, borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              child: Icon(
                Icons.add,
                color: BlackColor,
              ),
              onTap: () {
                cartProv.setCurrentCart(cart!);
                cartProv.increasCartQuantity();
                basketPorv.updateBasketCart(cartProv.cart, basket!);
                setState(() {
                  cart = cartProv.cart;
                  _price = cartProv.cart.cartItemPrice!;
                  _quantity = cartProv.cart.cartItemQuantity!;
                });
              },
            )),
      ],
    );
  }
}
