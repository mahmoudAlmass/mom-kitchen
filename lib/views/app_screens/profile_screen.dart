// import 'package:flutter/material.dart';
// import 'package:kitchen_ware_project/providers/user_provider.dart';
// import 'package:kitchen_ware_project/utli/router.dart';
// import 'package:kitchen_ware_project/views/app_screens/create_item.dart';
// import 'package:provider/provider.dart';
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final userProv= Provider.of<UserProvider>(context,listen:false);

//     return Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Column(
//               children: [
//                 userProv.logedUser!.isChief==true? IconButton(icon: Icon(Icons.add),
//                 onPressed: ()=>MyRouter.pushPage(context, CreateItemScreen()),
//                 ):Text("not chief"),
//                 IconButton(icon: Icon(Icons.person),
//                 onPressed: ()async{
//                   await userProv.changeChiefStatus(true).then((_) => print(userProv.logedUser!.isChief));

//                 },
//                 ),

//               ],
//             ),
//           ),
//     );
//   }
// }