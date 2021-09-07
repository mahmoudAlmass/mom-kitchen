// import 'package:flutter/material.dart';
// import 'package:kitchen_ware_project/components/loading_widget.dart';
// import 'package:kitchen_ware_project/services/authentication/auth.dart';

// class SignUp extends StatefulWidget {
//     final Function toggleView;
//   SignUp({required this.toggleView});
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   AuthService _auth= AuthService();
//   final _formkey=GlobalKey<FormState>();

//   bool loading = false;
//   String name='';
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
//                   Text("Register", style: TextStyle(color: Colors.white, fontSize: 40)),
//                   SizedBox(height: 10,),
//                   Text("Welcome To App", style: TextStyle(color: Colors.white, fontSize: 18),),
                
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
//                 child: SingleChildScrollView(
//                     child: Padding(
//                     padding: EdgeInsets.all(30),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 60,),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [BoxShadow(
//                               color: Color.fromRGBO(225, 95, 27, .3),
//                               blurRadius: 20,
//                               offset: Offset(0, 10)
//                             )]
//                           ),
//                           child:Form(
//                             key: _formkey,
//                             child:Column(
//                             children: <Widget>[
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   border: Border(bottom: BorderSide(color: Colors.grey[200]!))
//                                 ),
//                                 child: TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText: "Your name",
//                                     hintStyle: TextStyle(color: Colors.grey),
//                                     border: InputBorder.none
//                                   ),
//                                   obscureText: true,
//                                   //todo fill this 
//                                   validator: (_)=> null,
//                                   onChanged: (val)=>setState(() {name=val;}),
                                  
//                                 ),
                                
//                               ),
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   border: Border(bottom: BorderSide(color: Colors.grey[200]!))
//                                 ),
//                                 child: TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText: "Email",
//                                     hintStyle: TextStyle(color: Colors.grey),
//                                     border: InputBorder.none
//                                   ),
//                                   //todo fill this 
//                                   validator: (_)=> null,
//                                   onChanged: (val)=>setState(() {email=val;}),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   border: Border(bottom: BorderSide(color: Colors.grey[200]!))
//                                 ),
//                                 child: TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText: "Password",
//                                     hintStyle: TextStyle(color: Colors.grey),
//                                     border: InputBorder.none
//                                   ),
//                                   obscureText: true,
//                                   //todo fill this 
//                                   validator: (_)=> null,
//                                   onChanged: (val)=>setState(() {password=val;}),
//                                 ),
//                               ),
                              
//                             ],
//                           ) ,
//                           ) ,
                          
//                         ),
//                         SizedBox(height: 60,),
                        
                      
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("aldready have account?", style: TextStyle(color: Colors.grey)),
//                             TextButton(onPressed: (){
//                               widget.toggleView();
//                             }, 
//                               child: Text("Login", style: TextStyle(color: Colors.blueAccent),
//                               ),)
//                           ],
//                         ),
                        
//                         SizedBox(height: 20,),
//                           Container(
//                           height: 50,
//                           margin: EdgeInsets.symmetric(horizontal: 50),
//                           child: Center(
                            
//                             child:ElevatedButton(
//                               onPressed: () async{
//                               if(_formkey.currentState!.validate()){
//                                 setState(() => loading= true);
//                                 dynamic res = await _auth.registerWithEmailAndPassword(email,password,name);
//                                 if(res==null){
//                                   setState((){
//                                     error='something want wrong!';
//                                     loading = false;
//                                   });
//                                 }
//                               }
//                             },
//                               style: ButtonStyle(
//                                 shape:MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
//                                 backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[900]!),
                                
//                               ),
//                               child:  Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 15),
//                                 child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//                               ),
//                               ),
//                           ),
//                         ),
                      
//                       ],
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




import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/services/authentication/auth.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:kitchen_ware_project/widgets/text_field_container.dart';

import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:provider/provider.dart';
class SignUp extends StatefulWidget {
    final Function toggleView;
  SignUp({required this.toggleView});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUp> {
  AuthService _auth = AuthService();
  bool loading = false;
  String name = '';
  String email = '';
  String password = '';
  String error = '';
  late bool isChief ;
  @override
  void initState() {
    isChief=false;
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return _isLoading==true? LoadingWidget(): Scaffold(
                extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,
          actions:[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                icon: Icon(Icons.arrow_forward,size: 32,color: OrangeColor,),
                  onPressed: ()async{

                    await _auth.signInAnonymously();

                  },
                ),
              ),
            ],
          ),
        body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: deviceSize.height * 0.2,),
            Text(
              "SIGN-UP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: deviceSize.height * 0.03),
            // Container(
            //   width: 240,
            //   height: 240,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage("assets/images/signUp.png"),
            //         fit: BoxFit.cover,
            //       ),
            //       borderRadius: BorderRadius.circular(7.0)),
            // ),
            TextFieldContainer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  icon: Icon(
                    Icons.person,
                    color: BlackColor,
                  ),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
                validator: (_) => null,
                onChanged: (val) => setState(() {
                  name = val;
                }),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email_outlined,
                    color: BlackColor,
                  ),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide your email';
                  }
                  return null;
                },
                onChanged: (val) => setState(() {
                  email = val;
                }),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(
                    Icons.lock_outlined,
                    color: BlackColor,
                  ),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide your password';
                  }
                  return null;
                },
                onChanged: (val) => setState(() {
                  password = val;
                }),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            //Spacer(flex: 1),
            Text("what do you want to be ? ",
                style: TextStyle(color: LightBlackColor, fontSize: 16)),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedSmallButton(
                    text: "chief",
                    press: () {
          
                      setState(() {
                        isChief = true;
                      });
                    }),
                Divider(
                  thickness: 10,
                ),
                RoundedSmallButton(
                    text: "customer",
                    press: (){
                      setState(() {
                        isChief = false;
                      });
                    }),
              ],
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),

            RoundedButton(
              text: "SIGNUP",
              press: () async {
  setState(() {
  _isLoading=true;
});
                
                await _auth.registerWithEmailAndPassword(
                    email, password, name , isChief).then((_) {
                      setState(() {
  _isLoading=false;
});
                    });

              },
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("already have account?", style: TextStyle(color: Colors.grey)),
              TextButton(onPressed: (){
                widget.toggleView();
              }, 
                child: Text("Login", style: TextStyle(color: OrangeColor),
                ),)
            ],
          ),
          ],
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  
  return Container(
    height: size.height,
    width: double.infinity,
    // Here i can use size.width but use double.infinity because both work as a same
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset(
            "assets/images/signup_top.png",
            width: size.width * 0.35,
          ),
        ),
      ],
    ),
  );
}

class RoundedSmallButton extends StatefulWidget {
  final String? text;
  final Function()? press;
  final Color? color, textColor;


  const RoundedSmallButton({
    Key? key,
    this.text,
    this.press,
    this.color = Colors.white,
    this.textColor = OrangeColor,
  }) : super(key: key);

  @override
  State<RoundedSmallButton> createState() => _RoundedSmallButtonState();
}

class _RoundedSmallButtonState extends State<RoundedSmallButton> {
  bool pressed=false;
  late Color color;
  late Color textColor;
  @override
  void initState() {
    color=widget.color!;
    textColor=widget.textColor!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.4,
      height: size.height * 0.06,
      child: FlatButton(
        color: color,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: OrangeColor,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(30)),
            
        onPressed:(){
          widget.press!.call();
            setState(() {
              pressed=!pressed;
                Color temp=color;
                color=textColor;
                textColor=temp;
            });
        },
        child: Text(
          widget.text!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

