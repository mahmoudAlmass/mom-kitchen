import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/orders.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/widgets/order_item.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
// this is for user
class OrdersScreen extends StatefulWidget {

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _pending_expanded = false;
  bool _confirmed_expanded = false;
  bool _isLoading=true;
  bool _isInit=true;
  List<Order> _orders =[];
  List<Order> pendingSingleOrders = [];
  List<Order> confirmedSingleOrders = [];


  @override
  void didChangeDependencies()async{
    if(_isInit){
    final userProv= Provider.of<UserProvider>(context,listen: false);
    await Provider.of<OrderProvider>(context, listen: true)
    .fetchActiveOrdersByUserId(userProv.logedUser!.userID!,"active_orders").then((orders) {
      setState(() {
        _orders=orders;
        if (_orders.isNotEmpty) {
        pendingSingleOrders =
        _orders.where((element) => element.orderState.toString().split(".").last =="pending").toList();
        confirmedSingleOrders =
        _orders.where((element) => element.orderState.toString().split(".").last  !="pending").toList();
        }

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
    
    return _isLoading? LoadingWidget(): Scaffold(
      body: SingleChildScrollView(
              child: Column(
          children: [
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
                  Text("Your Orders",
                      style: TextStyle(color: LightBlackColor, fontSize: 22)),
                ],
              ),
            ),
            SizedBox(height: deviceSize.height * 0.05),
            Container(
              padding: EdgeInsets.only(
                  left: deviceSize.width * 0.03, right: deviceSize.width * 0.03),
              child: Column(
                children: [
                  pendingSingleOrders.isEmpty &&
                            pendingSingleOrders.length == 0
                        ? ListTile(
                            title: Text('there is no pending orders',
                                style: TextStyle(color: Colors.black)),
                          )
                        : singleOrdersWidget(
                            singleOrders: pendingSingleOrders,
                            isPending: true,
                          ),
                            Divider(height: 50,),
                            confirmedSingleOrders.isEmpty &&
                            confirmedSingleOrders.length == 0
                        ? ListTile(
                            title: Text('there is no confirmed orders',
                                style: TextStyle(color: Colors.black)),
                          )
                        : singleOrdersWidget(
                            singleOrders: confirmedSingleOrders,
                            isPending: true,
                          ),
                ],
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
