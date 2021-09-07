import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/category.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/modules/firestore_upload_images.dart';
import 'package:kitchen_ware_project/modules/image_picker.dart';
import 'package:kitchen_ware_project/providers/categoreis_provider.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/meal_detail_screen.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewMealScreen extends StatefulWidget {
  final Meal? meal;

  const AddNewMealScreen({Key? key, required this.meal}) : super(key: key);

  @override
  AddNewMealScreenState createState() => AddNewMealScreenState();
}

class AddNewMealScreenState extends State<AddNewMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mealTitleNode = FocusNode();
  final _mealDurationNode = FocusNode();
  final _mealPriceNode = FocusNode();
  final _mealDescNode = FocusNode();

  late User logedUser;

  Meal _editedMeal = Meal();
  late bool isEdit;

  late String _current_image;
  @override
  void initState() {
    _editedMeal = widget.meal!;
    _current_image = _editedMeal.imageUrl ??
        "https://firebasestorage.googleapis.com/v0/b/kitchen-9213d.appspot.com/o/image-not-found.jpg?alt=media&token=bce9cb27-cb36-4f58-9dde-406c449b74ff";
    _editedMeal = _editedMeal.copyWith(imageUrl: _current_image);

    setState(() {
      isEdit = false;
      logedUser = Provider.of<UserProvider>(context, listen: false).logedUser!;
      Provider.of<CategoriesProvider>(context, listen: false)
          .clearCategoriesForNewMeal();
    });
    super.initState();
  }

  @override
  void dispose() {
    _mealTitleNode.dispose();
    _mealDurationNode.dispose();
    _mealPriceNode.dispose();
    _mealDescNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    _formKey.currentState!.save();
    try {
      List<Category> _editedCategories =
          Provider.of<CategoriesProvider>(context, listen: false)
              .editedCategories;
      Map<String, String> _cats = {};
      _editedCategories.forEach((element) {
        _cats.putIfAbsent(element.title!, () => element.title!);
      });
      _editedMeal = _editedMeal.copyWith(chefId: logedUser.userID, cats: _cats);
      if (widget.meal!.id != null) {
        setState(() {
          isEdit = true;
        });
        await Provider.of<MealProvider>(context, listen: false)
            .updateMeal(_editedMeal);
      } else {
        _editedMeal = _editedMeal.copyWith(id: Uuid().v4(),rate: 2.5,raterNumber: 1);
        await Provider.of<MealProvider>(context, listen: false)
            .newAddMeal(_editedMeal);
      }
      MyRouter.pushPageReplacement(
          context,
          isEdit == true
              ? MealDetail(_editedMeal)
              : ChefProfileScreen(logedUser.userID.toString()));
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

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        body: ListView(children: [
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
                    "add a new delicious meal",
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
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text("meal image",
                            style: TextStyle(
                                fontSize: 18, color: LightBlackColor))),
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: deviceSize.width * 0.85,
                          height: deviceSize.width * 0.5,
                          decoration: _current_image != ""
                              ? BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(_current_image),
                                      fit: BoxFit.fill))
                              : BoxDecoration(),
                        ),
                        Positioned(
                          left: deviceSize.width * 0.32,
                          top: deviceSize.height * 0.11,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: GrayColor.withOpacity(0.8),
                                  )
                                ]),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: BlackColor.withOpacity(0.9),
                                    size: 35,
                                  ),
                                  onPressed: () async {
                                    await FirestoreUploadImages()
                                        .getImage(false)
                                        .then((url) {
                                      if (url.isNotEmpty) {
                                        setState(() {
                                          _current_image = url.toString();
                                        });
                                        print(url);
                                        _editedMeal = _editedMeal.copyWith(
                                            imageUrl: url.toString());
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: GrayColor.withOpacity(0.8),
                                  )
                                ]),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera,
                                    color: BlackColor.withOpacity(0.9),
                                    size: 35,
                                  ),
                                  onPressed: () async {
                                    await FirestoreUploadImages()
                                        .getImage(true)
                                        .then((url) {
                                      if (url.isNotEmpty) {
                                        setState(() {
                                          _current_image = url.toString();
                                        });
                                        _editedMeal = _editedMeal.copyWith(
                                            imageUrl: url.toString());
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.04,
                    ),
                    Row(
                      children: [
                        new DesignedTextField(
                          text: "Meal title",
                          fieldColor: Colors.purple.shade50,
                          initialValue: _editedMeal.title,
                          textFieldWidth: deviceSize.width * 0.4,
                          keyboardType: TextInputType.text,
                          submitField: (_) {
                            FocusScope.of(context).requestFocus(_mealTitleNode);
                          },
                          textFieldValidator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Please enter title";
                            }
                          },
                          save: (value) {
                            _editedMeal = _editedMeal.copyWith(title: value);
                          },
                        ),
                        SizedBox(width: deviceSize.width * 0.1),
                        new DesignedTextField(
                          text: "Meal Duration",
                          fieldColor: Colors.blue.shade50,
                          initialValue:
                              _editedMeal.duration.toString() != "null"
                                  ? _editedMeal.duration.toString()
                                  : "",
                          textFieldWidth: deviceSize.width * 0.4,
                          keyboardType: TextInputType.number,
                          textFieldValidator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "please enter duration";
                            }
                          },
                          save: (value) {
                            _editedMeal = _editedMeal.copyWith(
                                duration: int.parse(value!));
                          },
                          submitField: (_) {
                            FocusScope.of(context)
                                .requestFocus(_mealDurationNode);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    Row(
                      children: [
                        DesignedTextField(
                            text: "Meal Price",
                            fieldColor: Colors.blue.shade50,
                            initialValue: _editedMeal.price.toString() != "null"
                                ? _editedMeal.price.toString()
                                : "",
                            textFieldWidth: deviceSize.width * 0.4,
                            keyboardType: TextInputType.number,
                            textFieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            save: (value) {
                              _editedMeal = _editedMeal.copyWith(
                                  price: double.parse(value!));
                            }),
                        SizedBox(width: deviceSize.width * 0.1),
                        DesignedTextField(
                          text: "Sales",
                          fieldColor: Colors.purple.shade50,
                          textFieldWidth: deviceSize.width * 0.4,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    DesignedTextField(
                      text: "Meal Description",
                      fieldColor: Colors.deepPurple.shade50,
                      initialValue: _editedMeal.description,
                      textFieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      save: (value) {
                        _editedMeal = _editedMeal.copyWith(description: value);
                      },
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text("Meal Categories",
                            style: TextStyle(
                                fontSize: 18, color: LightBlackColor))),
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    CategoryItemGrid(),
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    RoundedButton(
                      color: OrangeColor,
                      text: "Submit",
                      press: () async {
                        // _formKey.currentState!.validate();
                        if (_formKey.currentState!.validate()) {
                          await _saveForm().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('a new meal added !')),
                            );
                          });
                        }
                      },
                    ),
                    SizedBox(height: deviceSize.height * 0.03),
                  ],
                ),
              ),
            ),
          ]),
    ]));
  }
}

class DesignedTextField extends StatelessWidget {
  final String? Function(String?)? textFieldValidator;
  final String? text;
  final String? initialValue;
  final Color? fieldColor;
  final double? textFieldWidth;
  final TextInputType? keyboardType;
  final void Function(String)? submitField;
  final void Function(String?)? save;

  const DesignedTextField(
      {Key? key,
      this.text,
      this.fieldColor,
      this.textFieldValidator,
      this.initialValue,
      this.textFieldWidth,
      this.keyboardType,
      this.submitField,
      this.save})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      width: textFieldWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text(text!,
                  style: TextStyle(fontSize: 16, color: LightBlackColor))),
          TextFormField(
            initialValue: initialValue ?? "",
            keyboardType: keyboardType,
            cursorColor: LightBlackColor,
            decoration: InputDecoration(
              //error,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: fieldColor!,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: fieldColor,
              focusColor: Colors.amber,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldColor!,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: textFieldValidator,
            onFieldSubmitted: submitField,
            onSaved: save,
          ),
        ],
      ),
    );
  }
}

class CategoryItemGrid extends StatefulWidget {
  @override
  _CategoryItemGridState createState() => _CategoryItemGridState();
}

class _CategoryItemGridState extends State<CategoryItemGrid> {
  bool _isInit = true;
  bool _isLoading = true;

  // @override
  // void didChangeDependencies() async{
  //   if(_isInit){
  //     await Provider.of<CategoriesProvider>(context,listen: false).fetchAllCategories().then((_) {

  //       setState(() {
  //         _isInit=false;
  //         _isLoading=false;
  //       });
  //     });
  //   }
  //   super.didChangeDependencies();
  // }
  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<CategoriesProvider>(context);
    Size deviceSize = MediaQuery.of(context).size;
    print(categoriesData.dummy_categories.length);
    return Container(
      height: deviceSize.height * 0.35,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: categoriesData.dummy_categories.length,
        itemBuilder: (_, index) => Container(
          child: CategoryItem(
              categoriesData.dummy_categories[index].title!,
              categoriesData.dummy_categories[index].imageUrl!,
              index < 10 ? categoriesColors[index] : categoriesColors[0]),
        ),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final Color? color;
  Category currentCat = Category();

  CategoryItem(this.title, this.imageUrl, this.color) {
    currentCat = currentCat.copyWith(title: title, imageUrl: imageUrl);
  }

  @override
  CategoryItemState createState() => CategoryItemState();
}

class CategoryItemState extends State<CategoryItem> {
  bool? isChosed;

  @override
  void initState() {
    super.initState();
    isChosed = false;
  }

  toggleIsChosedStatus() {
    setState(() => isChosed = !isChosed!);
    if (isChosed == true) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .addCategoriesForNewMeal(widget.currentCat);
    } else {
      Provider.of<CategoriesProvider>(context, listen: false)
          .removeCategoriesForNewMeal(widget.currentCat);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        setState(() {
          toggleIsChosedStatus();
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: isChosed!
          ? Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(right: 15, left: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.01,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.title!,
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.01,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(right: 15, left: 10),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
    );
  }
}
