import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kitchen_ware_project/models/notifications.dart';


class NotificationHandler extends ChangeNotifier {

  var deviceToken;
  int counter=0;

  Future<void> sendPushMessage(var token,String title,Notifications notification) async {

    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    
var data={
            'title':title,
            'message': notification.notificationContent.toString(),
            'token': token.toString(),
        };

    try {
      await http.post(
        Uri.parse('https://kitchen-ware-notification.herokuapp.com/notification_handler.php'),
        body: data
      ).then((value) => print(value.statusCode));
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Future<void>initToken()async{
    await FirebaseMessaging.instance.getToken().then((value) {
      deviceToken=value;
      notifyListeners();
    });
  }

  List<Notifications>notifications=[];
  void litenToMessages(){
      
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      String imageUrl="";
      if(event.notification!.body!.toString().contains("new")){
        imageUrl="assets/images/new_order.png";
      }
        if(event.notification!.body!.toString().contains("cancelled")){
        imageUrl="assets/images/cancel_order.jpg";
      }
        if(event.notification!.body!.toString().contains("Confirmed")){
        imageUrl="assets/images/confirm_order.jpg";
      }
        if(event.notification!.body!.toString().contains("updated")){
        imageUrl="assets/images/change_status.png";
      }            
      notifications.add(Notifications(imageUrl: imageUrl,notificationContent: event.notification!.body!));
      counter++;
      notifyListeners();
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
      });

    
  }
  void clearCounter(){
    counter=0;
    notifyListeners();
  }

  

  Notifications? gettingOrderTemplate(String customerName ) {
    Notifications? gettingOrderNotification = Notifications();
    // gettingOrderNotification.notificationType = NotificationsType.gettingOrder;
    gettingOrderNotification.notificationContent =
        "you have a new order from " + customerName;
    gettingOrderNotification.imageUrl = "assets/images/fish_icon.png";
    return gettingOrderNotification;
  }

  Notifications cancellingOrderTemplate(String chefName) {
    Notifications? cancellingOrderNotification = Notifications();
    // cancellingOrderNotification.notificationType =
    //     NotificationsType.cancellingOrder;
    cancellingOrderNotification.notificationContent =
        "you order from " + chefName + " has been cancelled";
    cancellingOrderNotification.imageUrl = "assets/images/fries_icon.png";
    return cancellingOrderNotification;
  }

  Notifications confirmingOrderTemplate(String chefName) {
    Notifications? confirmingOrderNotification = Notifications();
    // confirmingOrderNotification.notificationType =
    //     NotificationsType.confirmingOrder;
    confirmingOrderNotification.notificationContent =
        "you order from " + chefName + " has been Confirmed";
    confirmingOrderNotification.imageUrl = "assets/images/kabab_icon.png";
    return confirmingOrderNotification;
  }

  Notifications changingOrderStatusTemplate(String chefName) {
    Notifications? changingOrderStatusNotification = Notifications();
    // changingOrderStatusNotification.notificationType =
    //     NotificationsType.changingOrderStatus;
    changingOrderStatusNotification.notificationContent =
        " your order status from " + chefName + " has been updated";
    changingOrderStatusNotification.imageUrl =
        "assets/images/cupcake_icon.png";
    return changingOrderStatusNotification;
  }
}