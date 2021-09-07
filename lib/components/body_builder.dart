// import 'package:flutter/material.dart';
// import '/components/error_widget.dart';
// import '/components/loading_widget.dart';

// import 'package:kitchen_ware_project/utli/enum/connectionStatus.dart';
// class BodyBuilder extends StatelessWidget {
//   final ConnectionStatus connectionStatus;
//   final Widget child;
//   final Function reload;

//   BodyBuilder(
//       {Key? key,
//       required this.connectionStatus,
//       required this.child,
//       required this.reload})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _buildBody();
//   }

//   Widget _buildBody() {
//     switch (connectionStatus) {
//       case ConnectionStatus.connectionError:
//         return MyErrorWidget(
//           refreshCallBack: reload,
//           isConnection: true,
//         );

//       default:
//         return LoadingWidget();
//     }
//   }
// }
