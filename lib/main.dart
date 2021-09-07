import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kitchen_ware_project/APIs/googleMap/map_app.dart';
import 'package:kitchen_ware_project/APIs/googleMap/placesProvider.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/models/cart.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/providers/basket_provider.dart';
import 'package:kitchen_ware_project/providers/cartProvider.dart';
import 'package:kitchen_ware_project/providers/categoreis_provider.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/report_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/services/authentication/auth.dart';
import 'package:kitchen_ware_project/services/connectivity.dart';
import 'package:kitchen_ware_project/shared/constants.dart';
import 'package:kitchen_ware_project/views/app_screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'models/user.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> _messageHandler(RemoteMessage remoteMessage) async {
  // print('background message ${message.notification!.body}');
  RemoteNotification? remoteNotification = remoteMessage.notification;


}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //this should reamin here at this level
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await Firebase.initializeApp();
  CategoriesProvider categoriesProvider= new CategoriesProvider();
  // await categoriesProvider.addRandomCategories();
  await InternetConnection().initConnectivity();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
        ChangeNotifierProvider<InternetConnection>(create: (context)=>InternetConnection(),), 
        ChangeNotifierProvider<UserProvider>( create: (context)=>UserProvider(),),
        ChangeNotifierProvider<MapState>(create: (context)=>MapState(),child: MapApp(),),
        ChangeNotifierProvider<AppProvider>(create: (context)=>AppProvider()),
        ChangeNotifierProvider<CategoriesProvider>.value(value: CategoriesProvider(),),
        ChangeNotifierProvider<MealProvider>.value(value: MealProvider(),),
        ChangeNotifierProvider<NotificationHandler>(create: (context)=>NotificationHandler()),
        ChangeNotifierProvider<PlacesProvider>(create: (context)=>PlacesProvider()),
        ChangeNotifierProvider<CartItems>(create: (context)=>CartItems()),
        ChangeNotifierProvider<CartProvider>(create: (context)=>CartProvider()),
        ChangeNotifierProvider<BasketProvider>(create: (context)=>BasketProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (context)=>OrderProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (context)=>ChatProvider()),
        ChangeNotifierProvider<ReportsProvider>(create: (context)=>ReportsProvider()),

      ],

    child: Consumer<AppProvider>(
      builder: ( context,  appProvider,  child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.AppName,
          theme: themeData(appProvider.theme),
          home: Splash(),
        );
      },
    ),

    );
    
  }
    ThemeData themeData(ThemeData theme) {
    return theme;
  }
}

