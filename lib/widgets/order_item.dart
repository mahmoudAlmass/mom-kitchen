import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/cart.dart';
import 'package:kitchen_ware_project/models/orders.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:provider/provider.dart';

class singleOrdersWidget extends StatelessWidget {
  List<Order>? singleOrders;
  bool? isPending;
  singleOrdersWidget({this.singleOrders, this.isPending});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: singleOrders!.length,
        itemBuilder: (ctx, i) => SingleOrderWidget(
          singleOrder: singleOrders![i],
          isPending: isPending,
        ),
      ),
    );
  }
}

class SingleOrderWidget extends StatefulWidget {
  Order? singleOrder;
  bool? isPending;
  SingleOrderWidget({this.singleOrder, this.isPending});

  @override
  State<SingleOrderWidget> createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  bool _isLoading = true;
  bool _isInit = true;
  User _cheif = User();
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchChiefByid(widget.singleOrder!.chiefId!)
          .then((cheif) {
        setState(() {
          _cheif = cheif;
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? ShimmerLoading()
        : 
        Padding(
          padding: EdgeInsets.only(
              left: deviceSize.width * 0.03,
              right: deviceSize.width * 0.03),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child:Row(
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
                    "Chef ${_cheif.userName!}",
                    
                    style: TextStyle(fontSize: 16),
                  ),
                    ],
                  ),
                    Text(
                      widget.singleOrder!.orderState
                          .toString()
                          .split(".")
                          .last,
                      style: TextStyle(fontSize: 18,color: AmberColor),
                    ),
                  ],
                ),
              ),
          
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              Container(
                // height: 150,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.singleOrder!.basket!.cartItems!.length,
                    itemBuilder: (context, index) => orderMealWidget(
                        meal:
                            widget.singleOrder!.basket!.cartItems![index])),
              ),
            ],
          ),
        );
  }
}

class orderMealWidget extends StatelessWidget {
  Cart? meal;

  orderMealWidget({this.meal});

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(
          bottom: deviceSize.height * 0.03,
          // left: deviceSize.width * 0.03,
          right: deviceSize.width * 0.07),
      height: deviceSize.height * 0.17,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            meal!.cartItemMeal!.imageUrl!,
            fit: BoxFit.cover,
            width: deviceSize.width * 0.3,
            height: deviceSize.height * 0.15,
          ),
          SizedBox(width: deviceSize.width * 0.04),
          Container(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal!.cartItemMeal!.title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                Text(
                  '\$${meal!.cartItemPrice}',
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
      
    );
    
  }
}
