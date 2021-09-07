import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/chat.dart';
import 'package:kitchen_ware_project/models/orders.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/chat_screens/chat_screen.dart';
import 'package:kitchen_ware_project/widgets/order_item.dart';
import 'package:kitchen_ware_project/widgets/stepper.dart';
import 'package:provider/provider.dart';

class ChefOrdersScreen extends StatefulWidget {
  @override
  _ChefOrdersScreenState createState() => _ChefOrdersScreenState();
}

class _ChefOrdersScreenState extends State<ChefOrdersScreen> {
  bool _pending_expanded = false;
  bool _confirmed_expanded = false;

  bool _isLoading = true;
  bool _isInit = true;
  List<Order> _orders = [];
  List<Order> pendingSingleOrders = [];
  List<Order> confirmedSingleOrders = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final userProv = Provider.of<UserProvider>(context, listen: false);
      final orderProv = Provider.of<OrderProvider>(context, listen: true);
      await orderProv
          .fetchActiveOrdersByUserId(
              userProv.logedUser!.userID!, "requested_orders")
          .then((orders) {
        setState(() {
          _orders = orderProv.orders;
          pendingSingleOrders = orderProv.pendingSingleOrders;
          confirmedSingleOrders = orderProv.confirmedSingleOrders;
          _isLoading = false;
          _isInit = false;
        });
      });
    } else {
      final orderProv = Provider.of<OrderProvider>(context, listen: true);
      setState(() {
        _orders = orderProv.orders;
        pendingSingleOrders = orderProv.pendingSingleOrders;
        confirmedSingleOrders = orderProv.confirmedSingleOrders;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? LoadingWidget()
        : Scaffold(
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
                          icon: Icon(Icons.arrow_back_ios,
                              color: LightBlackColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: deviceSize.width * 0.1),
                        Text("Chef Orders",
                            style: TextStyle(
                              color: LightBlackColor,
                              fontSize: 22,
                            )),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ChefsingleOrdersWidget(
                        singleOrders: pendingSingleOrders,
                        isPending: true,
                      ),
                      Divider(),
                      ChefsingleOrdersWidget(
                        singleOrders: confirmedSingleOrders,
                        isPending: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class ChefsingleOrdersWidget extends StatefulWidget {
  List<Order>? singleOrders;
  bool? isPending;
  ChefsingleOrdersWidget({this.singleOrders, this.isPending});

  @override
  State<ChefsingleOrdersWidget> createState() => _ChefsingleOrdersWidgetState();
}

class _ChefsingleOrdersWidgetState extends State<ChefsingleOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
      // height: deviceSize.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.singleOrders!.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) => ChefSingleOrderWidget(
            singleOrder: widget.singleOrders![i],
            isPending: widget.isPending,
          ),
        ),
      ),
    );
  }
}

class ChefSingleOrderWidget extends StatefulWidget {
  Order? singleOrder;
  bool? isPending;
  ChefSingleOrderWidget({this.singleOrder, this.isPending});

  @override
  State<ChefSingleOrderWidget> createState() => _ChefSingleOrderWidgetState();
}

class _ChefSingleOrderWidgetState extends State<ChefSingleOrderWidget> {
  late bool isPending;
  @override
  void initState() {
    isPending = widget.isPending!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
          left: deviceSize.width * 0.05,
          right: deviceSize.width * 0.03,
          top: deviceSize.height * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: deviceSize.height * 0.03,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.singleOrder!.basket!.cartItems!.length,
            itemBuilder: (context, index) => orderMealWidget(
                meal: widget.singleOrder!.basket!.cartItems![index]),
          ),
          isPending == false
              ? ChangeStatusWidget(
                  singleOrder: widget.singleOrder,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                  'are you sure you want to confirme this order?'),
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
                                    //   showDialog(context: ctx, builder: (c)=>AlertDialog(
                                    //   content:
                                    //     Container(child: CircularProgressIndicator())

                                    // ));
                                    final user =
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .fetchChiefByid(
                                                widget.singleOrder!.userId!);
                                    final cheif =
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .fetchChiefByid(
                                                widget.singleOrder!.chiefId!);
                                    // get device token / cheif name
                                    String token = user.deviceToken!;
                                    String cheifName = cheif.userName!;
                                    await Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .changeOrderState(
                                            widget.singleOrder!, "confirmed")
                                        .then((_) async {
                                          final notiProv=Provider.of<NotificationHandler>(
                                              context,
                                              listen: false);
                                      await notiProv
                                          .sendPushMessage(
                                              token,
                                              "mom's kitchen",
                                            notiProv
                                                  .confirmingOrderTemplate(
                                                      cheifName))
                                          .then((_) {
                                        Navigator.of(ctx).pop(true);
                                      });
                                      // Navigator.of(ctx).pop(true);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.check)),
                    IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                  'are you sure you want to delete this order?'),
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
                                    final user =
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .fetchChiefByid(
                                                widget.singleOrder!.userId!);
                                    final cheif =
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .fetchChiefByid(
                                                widget.singleOrder!.chiefId!);
                                    // get device token / cheif name
                                    String token = user.deviceToken!;
                                    String cheifName = cheif.userName!;

                                    await Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .deleteOrder(widget.singleOrder!, false)
                                        .then((_) async {
                                      await Provider.of<NotificationHandler>(
                                              context,
                                              listen: false)
                                          .sendPushMessage(
                                              token,
                                              "mom's kitchen",
                                              Provider.of<NotificationHandler>(
                                                      context,
                                                      listen: false)
                                                  .cancellingOrderTemplate(
                                                      cheifName));
                                    });
                                    Navigator.of(ctx).pop(true);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.cancel)),
                          IconButton(onPressed: ()async{
                          final userProv=Provider.of<UserProvider>(context,listen:false);
                          User other= await userProv.fetchChiefByid(widget.singleOrder!.userId!);
                          Chat chat=await Provider.of<ChatProvider>(context,listen:false).initChat(widget.singleOrder!.chiefId!,widget.singleOrder!.userId!);
                          MyRouter.pushPage(context, ChatScreen(other: other, chat: chat));
                        }, 
                        icon: Icon(Icons.message_rounded)),

                    // RoundedButton(
                    //   width: 50,
                    //   text: "Confrim",
                    //   color: Colors.green.shade400,
                    //   textColor: Colors.white,
                    //   press: () {},
                    // ),
                    // SizedBox(width: deviceSize.width * 0.1),
                    // RoundedButton(
                    //   width: 50,
                    //   text: "Discard",
                    //   color: Colors.red.shade400,
                    //   textColor: Colors.white,
                    //   press: () {},
                    // ),
                  ],
                )
        ],
      ),
    );
  }
}

class ChangeStatusWidget extends StatefulWidget {
  Order? singleOrder;

  ChangeStatusWidget({Key? key, this.singleOrder}) : super(key: key);

  @override
  _ChangeStatusWidgetState createState() =>
      _ChangeStatusWidgetState(singleOrder: singleOrder);
}

class _ChangeStatusWidgetState extends State<ChangeStatusWidget> {
  Order? singleOrder;

  _ChangeStatusWidgetState({this.singleOrder});
  int startFrom = 0;
  @override
  void initState() {
    String state = singleOrder!.orderState.toString().split(".").last;
    switch (state) {
      case "preparing":
        {
          startFrom = 1;
        }
        break;
      case "ready":
        {
          startFrom = 2;
        }
        break;
      case "delevered":
        {
          startFrom = 3;
        }
        break;
      default:
        {
          startFrom = 0;
        }
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: HorizontalStepper(
        startFrom: startFrom,
        order: singleOrder!,
        steps: [
          HorizontalStep(
            title: "confirmed",
            widget: Container(width: 1, height: 10),
            state: HorizontalStepState.SELECTED,
            isValid: true,
          ),
          HorizontalStep(
            title: "preparing",
            widget: Container(width: 1, height: 10),
            state: startFrom >= 1
                ? HorizontalStepState.SELECTED
                : HorizontalStepState.UNSELECTED,
            isValid: true,
          ),
          HorizontalStep(
            title: "ready",
            state: startFrom >= 2
                ? HorizontalStepState.SELECTED
                : HorizontalStepState.UNSELECTED,
            widget: Container(width: 1, height: 10),
            isValid: true,
          ),
          HorizontalStep(
            title: "delevered",
            state: startFrom >= 3
                ? HorizontalStepState.SELECTED
                : HorizontalStepState.UNSELECTED,
            widget: Container(width: 1, height: 10),
            isValid: true,
          ),
        ],
        selectedColor: OrangeColor,
        unSelectedColor: GrayColor,
        rightBtnColor: GrayColor,
        selectedOuterCircleColor: LightOrangeColor,
        type: Type.TOP,
        circleRadius: 30,
        onComplete: () async {
          await Provider.of<OrderProvider>(context, listen: false)
              .changeOrderState(singleOrder!, "delevered")
              .then((_) async {
            await Provider.of<OrderProvider>(context, listen: false)
                .deleteOrder(singleOrder!, true);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('order is done!'),
              duration: const Duration(seconds: 1),
            ));
          });
        },
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: null,
        ),
        btnTextColor: Colors.amber,
      ),
    );
  }
}
