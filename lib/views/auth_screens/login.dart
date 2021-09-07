// import 'package:flutter/material.dart';
// import 'package:kitchen_ware_project/components/loading_widget.dart';
// import 'package:kitchen_ware_project/services/authentication/auth.dart';

// class Login extends StatefulWidget {

//   final Function toggleView;
//   Login({required this.toggleView});

//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//     AuthService _auth= AuthService();
//   final _formkey=GlobalKey<FormState>();
//   bool loading = false;
//   String email = '';
//   String password ='';
//   String error='';
//   @override
//   Widget build(BuildContext context) {
//     return loading? LoadingWidget(): Scaffold(
//         extendBodyBehindAppBar: true,
//           appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,
//           actions:[
//               IconButton(
//               icon: Icon(Icons.arrow_forward,size: 32,),
//                 onPressed: ()async{
//                   await _auth.signInAnonymously();
//                 },
//               ),
//             ],
//           ),
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             colors: [
//               Colors.orange[900]!,
//               Colors.orange[800]!,
//               Colors.orange[400]!
//             ]
//           )
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 80,),
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text("Login", style: TextStyle(color: Colors.white, fontSize: 40)),
//                   SizedBox(height: 10,),
//                   Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),),
                
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
//                 ),
                
//                 child: Container(
//                   padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 60,),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [BoxShadow(
//                                 color: Color.fromRGBO(225, 95, 27, .3),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10)
//                               )]
//                             ),
//                             child:Form(
//                               key: _formkey,
//                               child:Column(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     border: Border(bottom: BorderSide(color: Colors.grey[200]!))
//                                   ),
//                                   child: TextFormField(
//                                     decoration: InputDecoration(
//                                       hintText: "Email",
//                                       hintStyle: TextStyle(color: Colors.grey),
//                                       border: InputBorder.none
//                                     ),
//                                     //todo fill this 
//                                     validator: (_)=> null,
//                                   onChanged: (val)=>setState(() {email=val;}),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     border: Border(bottom: BorderSide(color: Colors.grey[200]!))
//                                   ),
//                                   child: TextFormField(
//                                     decoration: InputDecoration(
//                                       hintText: "Password",
//                                       hintStyle: TextStyle(color: Colors.grey),
//                                       border: InputBorder.none
//                                     ),
//                                     obscureText: true,
//                                     //todo fill this 
//                                     validator: (_)=> null,
//                                   onChanged: (val)=>setState(() {password=val;}),
//                                   ),
//                                 ),
//                               ],
//                             ) ,
//                             ) 
                            
//                           ),
//                           SizedBox(height: 60,),
                          
//                           TextButton(onPressed: (){}, 
//                           child: Text("Forgot Password?", style: TextStyle(color: Colors.grey),
//                           ),),
//                           SizedBox(height: 5,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Do not have account?", style: TextStyle(color: Colors.grey)),
//                               TextButton(onPressed: (){
//                                 widget.toggleView();
//                               }, 
//                                 child: Text("Create one", style: TextStyle(color: Colors.blueAccent),
//                                 ),)
//                             ],
//                           ),
                          
//                           SizedBox(height: 20,),
//                           Container(
//                             height: 50,
//                             margin: EdgeInsets.symmetric(horizontal: 50),
//                             child: Center(
                              
//                               child:ElevatedButton(
//                               onPressed: () async{
//                               if(_formkey.currentState!.validate()){
//                                 setState(() => loading= true);
//                                 dynamic res = await _auth.signInWithEmailAndPassword(email,password);
//                                 if(res==null){
//                                   setState((){
//                                     error='something want wrong!';
//                                     loading = false;
//                                   });
//                                 }
//                               }
//                             },
//                                 style: ButtonStyle(
//                                   shape:MaterialStateProperty.all<RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
//                                   backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[900]!),
                                  
//                                 ),
//                                 child:  Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 15),
//                                   child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//                                 ),
//                                 ),
//                             ),
//                           ),
                        
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }