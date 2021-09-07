import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/orders.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:provider/provider.dart';
const double MARGIN_NORMAL = 16;
const double CHIP_BORDER_RADIUS = 30;
const double MARGIN_SMALL = 8;
const double PADDING_SMALL = 8;

enum HorizontalStepState { SELECTED, UNSELECTED }

enum Type { TOP, BOTTOM }

class HorizontalStep {
  final String? title;
  final Widget? widget;
  bool? isValid;
  HorizontalStepState? state;

  HorizontalStep({
    @required this.title,
    @required this.widget,
    this.state = HorizontalStepState.UNSELECTED,
    this.isValid,
  });
}

class HorizontalStepper extends StatefulWidget {
  final List<HorizontalStep> steps;
  final Color selectedColor;
  final double circleRadius;
  final Color unSelectedColor;
  final Color selectedOuterCircleColor;
  final TextStyle textStyle;
  final Color rightBtnColor;
  final Type type;
  final VoidCallback onComplete;
  final Color btnTextColor;
  final Order order;
  final int startFrom;

  const HorizontalStepper({
    required this.steps,
    required this.selectedColor,
    required this.circleRadius,
    required this.unSelectedColor,
    required this.selectedOuterCircleColor,
    required this.textStyle,
    required this.rightBtnColor,
    required this.type,
    required this.onComplete,
    required this.btnTextColor,
    required this.order,
    required this.startFrom,
  });

  @override
  State<StatefulWidget> createState() => _HorizontalStepperState(
        steps: this.steps,
        selectedColor: selectedColor,
        unSelectedColor: unSelectedColor,
        circleRadius: circleRadius,
        selectedOuterCircleColor: selectedOuterCircleColor,
        textStyle: textStyle,
        type: type,
        rightBtnColor: rightBtnColor,
        onComplete: onComplete,
        btnTextColor: btnTextColor,
        order:order,
        startFrom: startFrom
      );
}

class _HorizontalStepperState extends State<StatefulWidget> {
  final List<HorizontalStep> steps;
  final Color selectedColor;
  final Color unSelectedColor;
  final double circleRadius;
  final TextStyle textStyle;
  final Type type;
  final Color rightBtnColor;
  final VoidCallback onComplete;
  final Color btnTextColor;
  Order order;
  final int startFrom;


  Color selectedOuterCircleColor;
  PageController? _controller;
  int currentStep = 0;

  _HorizontalStepperState({
    required this.steps,
    required this.selectedColor,
    required this.circleRadius,
    required this.unSelectedColor,
    required this.selectedOuterCircleColor,
    required this.textStyle,
    required this.type,
    required this.rightBtnColor,
    required this.onComplete,
    required this.btnTextColor,
    required this.order,
    required this.startFrom

  });

  @override
  void initState() {
    currentStep=startFrom;
    _controller = PageController();
    _controller!.addListener(() {
      if (!steps[currentStep].isValid!) {
        _controller!.jumpToPage(currentStep);
      }
    });
    super.initState();
  }

  void changeStatus(int index) {
    if (isForward(index)) {
      markAsCompletedForPrecedingSteps();
    } else {
      markAsUnselectedToSucceedingSteps();
    }
    setState(() {
      currentStep = index;
      steps[index].state = HorizontalStepState.SELECTED;
    });
  }

  void markAsUnselectedToSucceedingSteps() {
    for (int i = steps.length - 1; i >= currentStep; i--) {
      steps[i].state = HorizontalStepState.UNSELECTED;
    }
  }

  void markAsCompletedForPrecedingSteps() {
    for (int i = 0; i <= currentStep; i++) {
      steps[i].state = HorizontalStepState.SELECTED;
    }
  }
// here what the hack was that
  bool _isLast(int index) {
    return steps.length == index+2;
  }

  void _goToNextPage() {
    if (_isLast(currentStep)) {
      onComplete.call();
    }
    if (currentStep < steps.length - 1) {
      currentStep++;
      setState(() {});
      _controller!.jumpToPage(currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(children: [
      Row(
        children: [_getIndicatorWidgets(deviceWidth * 0.7), _getButton()],
      ),
      Container(height: 10, child: _getPageWidgets()),
      _getTitleWidgets(deviceWidth * 0.7),
    ]);
  }

  Widget _getPageWidgets() {
    return Container(
      height: 10,
      child: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() {
          changeStatus(index);
        }),
        children: _getPages(),
      ),
    );
  }

  Widget _getIndicatorWidgets(double width) {
    return Container(
      width: width,
      child: Row(
        children: _getStepCircles(),
      ),
    );
  }

  Widget _getTitleWidgets(double width) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Container(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "confirmed",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "preparing",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ready",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "delevered",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getButton() {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: steps[currentStep].title != "delevered"
          ? IconButton(
              icon: Icon(Icons.arrow_forward_outlined,
                  color: LightBlackColor, size: 30),
              onPressed: () {
                steps[currentStep + 1].isValid!
                    ? showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                            'are you sure that this order is ' +
                                steps[currentStep + 1].title! +
                                " ?",
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
                              onPressed: () async{
                                // showDialog(context: ctx, builder: (c)=>AlertDialog(
                                //   content:
                                //     Container(width: 100,height: 100,child: CircularProgressIndicator())
                                  
                                // ));
                                await Provider.of<OrderProvider>(context,listen:false)
                                .changeOrderState(order, steps[currentStep+1].title!);
                                // fetch user to send notification
                                final user = await Provider.of<UserProvider>(context,listen:false).fetchChiefByid(order.userId!);
                                final cheif = await Provider.of<UserProvider>(context,listen:false).fetchChiefByid(order.chiefId!);
                                // get device token / cheif name
                                String token = user.deviceToken!;
                                String cheifName= cheif.userName!;
                                final notHand=Provider.of<NotificationHandler>(context,listen: false);
                                await notHand
                                .sendPushMessage(token,"mom's kitchen",notHand
                                .changingOrderStatusTemplate(cheifName)).then((_) {
                                _goToNextPage();

                                Navigator.of(ctx).pop(true);

                                });

                                // Navigator.of(ctx).pop(true);
                              },
                            ),
                          ],
                        ),
                      )
                    : null;
              },
            )
          : Container(
              width: 10,
              height: 10,
            ),
    );
  }

  List<Widget> _getStepCircles() {
    List<Widget> widgets = [];
    steps.asMap().forEach((key, value) {
      widgets.add(_StepCircle(value, circleRadius, selectedColor,
          unSelectedColor, selectedOuterCircleColor));
      if (key != steps.length - 1) {
        widgets.add(_StepLine(
          steps[key + 1],
          selectedColor,
          unSelectedColor,
        ));
      }
    });
    return widgets;
  }

  List<Widget> _getPages() {
    return steps.map((e) => e.widget!).toList();
  }

  bool isForward(int index) {
    return index > currentStep;
  }
}

class _StepLine extends StatelessWidget {
  final HorizontalStep step;
  final Color selectedColor;
  final Color unSelectedColor;

  _StepLine(
    this.step,
    this.selectedColor,
    this.unSelectedColor,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(
        left: 4,
        right: 4,
      ),
      height: 2,
      color: step.state == HorizontalStepState.SELECTED
          ? selectedColor
          : unSelectedColor,
    ));
  }
}

class _StepCircle extends StatelessWidget {
  final HorizontalStep step;
  final double circleRadius;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color selectedOuterCircleColor;

  _StepCircle(
    this.step,
    this.circleRadius,
    this.selectedColor,
    this.unSelectedColor,
    this.selectedOuterCircleColor,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleRadius,
      width: circleRadius,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: _getColor(),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(circleRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          4,
        ),
        child: Container(
            decoration: BoxDecoration(
          color: step.state == HorizontalStepState.SELECTED
              ? selectedColor
              : unSelectedColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              circleRadius,
            ),
          ),
        )),
      ),
    );
  }

  Color _getColor() {
    if (step.state == HorizontalStepState.SELECTED) {
      return selectedOuterCircleColor != null
          ? selectedOuterCircleColor
          : selectedColor;
    }
    return unSelectedColor;
  }
}
