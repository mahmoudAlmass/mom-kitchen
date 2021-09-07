import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/services/authentication/auth.dart';
import 'package:kitchen_ware_project/services/authentication/wrapper.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/widgets/app_drawer.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:kitchen_ware_project/widgets/rounded_input_field.dart';
import 'package:kitchen_ware_project/widgets/rounded_password_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
    final Function toggleView;
  LoginScreen({required this.toggleView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading=false;
  void _saveForm() async{
    try{
 setState(() {
      _isLoading=true;
    });
    await _auth.signInWithEmailAndPassword(email, password).then((_) 
    {
      setState(() {
        _isLoading=false;
      });
    });
    }catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
   
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _isLoading==true ?LoadingWidget(): Scaffold(
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
        // drawer: AppDrawer(),
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                // SvgPicture.asset(
                //   "assets/icons/login.svg",
                //   height: size.height * 0.35,
                // ),
                SizedBox(height: size.height * 0.03),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        hintText: "Your Email",
                        onChanged: (value) => setState(() {
                          email = value;
                        }),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter your email.';
                        //   }
                        //   if (!value.contains("@")) {
                        //     return 'this is not an email.';
                        //   }
                        //   return null;
                        // },
                      ),
                      RoundedPasswordField(
                        onChanged: (value) => setState(() {
                          password = value;
                        }),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter your password.';
                        //   }
                        //   return null;
                        // },
                      ),
                      RoundedButton(
                        width: size.width * 0.6,
                        text: "LOGIN",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('you logged in successfully!'),
                            //     duration: Duration(seconds: 2),
                            //   ),
                            // );
                            _saveForm();
                          }
                        },
                      ),
                                  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("do not have account?", style: TextStyle(color: Colors.grey,fontSize: 12)),
              TextButton(onPressed: (){
                widget.toggleView();
              }, 
                child: Text("Rigester", style: TextStyle(color: OrangeColor),
                ),)
            ],
          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Background extends StatelessWidget {
  final Widget? child;
  const Background({
    Key? key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child!,
        ],
      ),
    );
  }
}
