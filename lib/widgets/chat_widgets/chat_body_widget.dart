// import 'package:flutter/material.dart';
// import 'package:kitchen_ware_project/models/user.dart';
// import 'package:kitchen_ware_project/views/chat_screens/chat_screen.dart';

// class ChatBodyWidget extends StatelessWidget {
//   final List<User> users;
//   const ChatBodyWidget({
//     required this.users,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Expanded(
//         child: Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//             ),
//           ),
//           child: buildChats(),
//         ),
//       );

//   Widget buildChats() => ListView.builder(
//         physics: BouncingScrollPhysics(),
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return Container(
//             height: 75,
//             child: ListTile(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => Chat(user: user),
//                 ));
//               },
//               leading: CircleAvatar(
//                 radius: 25,
//                 backgroundImage: NetworkImage(user.imageUrl!),
//               ),
//               title: Text(user.userName!),
//             ),
//           );
//         },
//         itemCount: users.length,
//       );
// }