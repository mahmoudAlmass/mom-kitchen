import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/googleMap/map_app.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/modules/firestore_upload_images.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';
import 'package:kitchen_ware_project/widgets/designed_text_field.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class EditChefProfileScreen extends StatefulWidget {
  User? user;
  EditChefProfileScreen({required this.user, Key? key}) : super(key: key);
  @override
  _EditChefProfileScreenState createState() => _EditChefProfileScreenState();
}

class _EditChefProfileScreenState extends State<EditChefProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chefNameNode = FocusNode();
  final _chefIntroductionNode = FocusNode();
  final _chefOpeningTimeNode = FocusNode();
  final _chefClosingTimeNode = FocusNode();
  final _chefLocationNode = FocusNode();

  User _editedChef = User();
  late String _profileImage;
  late String _backgroundImage;

  @override
  void initState() {
    _editedChef = widget.user!;
    _profileImage = _editedChef.imageUrl!;
    _backgroundImage = _editedChef.backgroungProfileImage!;

    super.initState();
  }

  @override
  void dispose() {
    _chefNameNode.dispose();
    _chefIntroductionNode.dispose();
    _chefOpeningTimeNode.dispose();
    _chefClosingTimeNode.dispose();
    super.dispose();
  }

  TimeOfDay? selectedOpeningTime;
  TimeOfDay? selectedClosingTime;

  Future<void> _selectOpeningTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedOpeningTime = picked;
      });
    }
  }

  Future<void> _selectClosingTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedClosingTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("building edit chef profile screen");

    Size deviceSize = MediaQuery.of(context).size;

    final loadedChief = _editedChef;

    void _saveForm() async {
      _formKey.currentState!.save();
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .updateCheifDetailes(_editedChef)
            .then((_) {
          Navigator.of(context).pop();
          MyRouter.pushPageReplacement(
              context, ChefProfileScreen(_editedChef.userID!));
        });
      } catch (error) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: deviceSize.height * 0.02,
                  left: deviceSize.width * 0.03,
                  right: deviceSize.width * 0.01,
                  bottom: deviceSize.height * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: LightBlackColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: deviceSize.width * 0.03),
                    Text(
                      "edit your profile",
                      style: TextStyle(color: LightBlackColor, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: deviceSize.width * 0.05,
                    left: deviceSize.width * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            height: deviceSize.height / 3,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          Container(
                            height: deviceSize.height / 3.5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.dstATop),
                                  image: NetworkImage(
                                    _backgroundImage,
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            left: deviceSize.width / 2.5,
                            top: deviceSize.height * 0.06,
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: GrayColor.withOpacity(0.8),
                                )
                              ]),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: BlackColor.withOpacity(0.8),
                                  size: 35,
                                ),
                                onPressed: () async {
                                  await FirestoreUploadImages()
                                      .getImage(false)
                                      .then((url) {
                                    if (url.isNotEmpty) {
                                      setState(() {
                                        _backgroundImage = url.toString();
                                      });
                                      _editedChef = _editedChef.copyWith(
                                          backgroungProfileImage:
                                              url.toString());
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: deviceSize.height / 4.8,
                            left: deviceSize.width / 2.9,
                            child: Container(
                              height: deviceSize.height * 0.12,
                              width: deviceSize.height * 0.13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  color: GrayColor,
                                  width: 5,
                                ),
                                image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.white.withOpacity(0.6),
                                      BlendMode.dstATop),
                                  image: NetworkImage(_profileImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: deviceSize.height / 4,
                            left: deviceSize.width / 2.3,
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: GrayColor.withOpacity(0.8),
                                )
                              ]),
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.add,
                                  color: BlackColor.withOpacity(0.9),
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await FirestoreUploadImages()
                                      .getImage(false)
                                      .then((url) {
                                    if (url.isNotEmpty) {
                                      setState(() {
                                        _profileImage = url.toString();
                                      });
                                      _editedChef = _editedChef.copyWith(
                                          imageUrl: url.toString());
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      DesignedTextField(
                        text: "Name",
                        fieldColor: Colors.purple.shade50,
                        initialValue: loadedChief.userName ?? "",
                        textFieldWidth: deviceSize.width * 0.4,
                        keyboardType: TextInputType.text,
                        submitField: (_) {
                          FocusScope.of(context).requestFocus(_chefNameNode);
                        },
                        save: (value) {
                          _editedChef = _editedChef.copyWith(userName: value);
                        },
                        textFieldValidator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please enter your name";
                          }
                        },
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      DesignedTextField(
                        text: "introudtion",
                        hintText: loadedChief.introduction,
                        fieldColor: Colors.purple.shade50,
                        initialValue: loadedChief.introduction ?? "",
                        textFieldWidth: deviceSize.width * 0.8,
                        keyboardType: TextInputType.text,
                        submitField: (_) {
                          FocusScope.of(context)
                              .requestFocus(_chefIntroductionNode);
                        },
                        // i commented this because i dont think that
                        // introduction is somthing so important
                        // textFieldValidator: (value) {
                        //   if (value!.isNotEmpty ||
                        //       loadedChief.introduction!.isNotEmpty) {
                        //     return null;
                        //   } else {
                        //     return "Please enter introduction";
                        //   }
                        // },
                        save: (value) {
                          _editedChef =
                              _editedChef.copyWith(introduction: value);
                        },
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      Row(
                        children: [
                          DesignedTextField(
                            readOnly: true,
                            text: "opening time",
                            hintText: selectedOpeningTime == null
                                ? loadedChief.openingTime == null
                                    ? ""
                                    : loadedChief.openingTime.toString()
                                : selectedOpeningTime!.hour.toString() +
                                    ":" +
                                    selectedOpeningTime!.minute.toString(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.edit, color: LightBlackColor),
                              onPressed: () {
                                _selectOpeningTime();
                              },
                            ),
                            fieldColor: Colors.purple.shade50,
                            textFieldWidth: deviceSize.width * 0.4,
                            keyboardType: TextInputType.datetime,
                            submitField: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_chefOpeningTimeNode);
                            },
                            save: (_) {
                              _editedChef = _editedChef.copyWith(
                                openingTime: selectedOpeningTime == null
                                    ? loadedChief.openingTime == null
                                        ? ""
                                        : loadedChief.openingTime.toString()
                                    : selectedOpeningTime!.hour.toString() +
                                        ":" +
                                        selectedOpeningTime!.minute.toString(),
                              );
                            },
                            // textFieldValidator: (value) {
                            //   if (value!.isNotEmpty) {
                            //     return null;
                            //   } else {
                            //     return "Please enter openeing time";
                            //   }
                            // },
                          ),
                          SizedBox(width: deviceSize.width * 0.05),
                          DesignedTextField(
                            readOnly: true,
                            text: "closing time",
                            hintText: selectedClosingTime == null
                                ? loadedChief.closingTime == null
                                    ? ""
                                    : loadedChief.closingTime.toString()
                                : selectedClosingTime!.hour.toString() +
                                    ":" +
                                    selectedClosingTime!.minute.toString(),

                            suffixIcon: IconButton(
                              icon: Icon(Icons.edit, color: LightBlackColor),
                              onPressed: () {
                                _selectClosingTime();
                              },
                            ),
                            fieldColor: Colors.purple.shade50,
                            textFieldWidth: deviceSize.width * 0.4,
                            keyboardType: TextInputType.text,
                            submitField: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_chefClosingTimeNode);
                            },
                            // textFieldValidator: (value) {
                            //   if (value!.isNotEmpty){
                            //     return null;
                            //   } else {
                            //     return "Please enter closing time";
                            //   }
                            // },
                            save: (_) {
                              _editedChef = _editedChef.copyWith(
                                closingTime: selectedClosingTime == null
                                    ? loadedChief.closingTime == null
                                        ? ""
                                        : loadedChief.closingTime.toString()
                                    : selectedClosingTime!.hour.toString() +
                                        ":" +
                                        selectedClosingTime!.minute.toString(),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.height * 0.03),
                      DesignedTextField(
                        readOnly: false,
                        text: "location",
                        fieldColor: Colors.purple.shade50,
                        initialValue: loadedChief.location ?? "",
                        textFieldWidth: deviceSize.width * 0.8,
                        keyboardType: TextInputType.text,
                        submitField: (_) {
                          FocusScope.of(context)
                              .requestFocus(_chefLocationNode);
                        },
                        textFieldValidator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please enter location";
                          }
                        },
                        save: (value) {
                          _editedChef = _editedChef.copyWith(location: value);
                        },
                      ),
                      SizedBox(height: deviceSize.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: deviceSize.height * 0.3,
                          width: deviceSize.height * 0.6,
                          child: MapApp(),
                        ),
                      ),
                      SizedBox(height: deviceSize.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        child: RoundedButton(
                          width: deviceSize.width * 0.6,
                          color: OrangeColor,
                          text: "Submit",
                          press: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('yout profile is updated !')),
                              );
                              _saveForm();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
