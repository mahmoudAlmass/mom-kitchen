import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/cart.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/basket_provider.dart';
import 'package:kitchen_ware_project/providers/cartProvider.dart';
import 'package:kitchen_ware_project/providers/categoreis_provider.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/report_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/services/authentication/authinticate.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/views/app_screens/meals_screen.dart';
import 'package:kitchen_ware_project/widgets/add_new_meal.dart';
import 'package:kitchen_ware_project/widgets/meal_item.dart';
import 'package:kitchen_ware_project/widgets/meals_list.dart';
import 'package:kitchen_ware_project/widgets/rating_meal.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';

class MealDetail extends StatefulWidget {
  Meal? _meal;

  MealDetail(Meal _meal) {
    this._meal = _meal;
  }

  @override
  _MealDetailState createState() => _MealDetailState();
}

class _MealDetailState extends State<MealDetail> {
  bool hadOrderd = false;
  User chef = User();
  bool _isLoading = true;
  IconData icon = Icons.favorite_border;
  bool _isFavorite = false;
  List<Meal>mealsSuggestion=[];
  @override
  void initState() {
    super.initState();
    if (_isLoading) {
      if (Provider.of<BasketProvider>(context, listen: false)
          .shouldRebuildCart(widget._meal!)) {
        WidgetsBinding.instance!.addPostFrameCallback((_) =>
            Provider.of<CartProvider>(context, listen: false).initCart());
      } else {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Cart cart = Provider.of<BasketProvider>(context, listen: false)
              .getCartBymeal(widget._meal!);
          Provider.of<CartProvider>(context, listen: false)
              .setCurrentCart(cart);
        });
      }
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (Provider.of<UserProvider>(context, listen: false).logedUser !=
            null) {
          await Provider.of<UserProvider>(context, listen: false)
              .hadOrderdThisMealBefor(widget._meal!.id!)
              .then((value) {
            setState(() {
              hadOrderd = value;
            });
          });

          await Provider.of<UserProvider>(context, listen: false)
              .isInFavorite(widget._meal!.id!)
              .then((value) {
            setState(() {
              _isFavorite = value;
              if (value == true) {
                icon = Icons.favorite_sharp;
              }
            });
          });
        }
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if(widget._meal!.cats!=null){
        await Provider.of<MealProvider>(context, listen: false).fetchSuggestion(widget._meal!).then((value){
          setState(() {
            
            mealsSuggestion=value;
            mealsSuggestion.removeWhere((element) => element.id==widget._meal!.id!);
          });
        });
        }
        await Provider.of<UserProvider>(context, listen: false)
            .fetchChiefByid(widget._meal!.chefId!)
            .then((value) {
          setState(() {
            chef = value;
            _isLoading = false;
          });
        });
      });
    }
  }

  double price = 2.5;
  double cleanness = 2.5;
  double taste = 2.5;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final basketProvider = Provider.of<BasketProvider>(context, listen: false);

    return _isLoading == true
        ? LoadingWidget()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: deviceSize.height * 0.06,
                      left: deviceSize.width * 0.01,
                      right: deviceSize.width * 0.01,
                      bottom: deviceSize.height * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: LightBlackColor),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                            Text(widget._meal!.title!,
                                style: TextStyle(
                                    color: LightBlackColor, fontSize: 22)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            hadOrderd == true
                                ? IconButton(
                                    icon: Icon(
                                      Icons.star_rate_outlined,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MealRatingBuilder(context);
                                          });
                                    },
                                    color: LightBlackColor,
                                  )
                                : Container(),
                            IconButton(
                                onPressed: () async {
                                  if (userProv.logedUser != null) {
                                    await Provider.of<ReportsProvider>(context,
                                            listen: false)
                                        .reportOnMeal(widget._meal!.id!,
                                            userProv.logedUser!.userID!)
                                        .then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            'you\'ve reported on this meal'),
                                        duration: const Duration(seconds: 1),
                                      ));
                                    });
                                  }
                                },
                                icon: Icon(Icons.report_outlined)),
                            userProv.logedUser!=null? IconButton(
                                onPressed: () async {
                                  final userProv = Provider.of<UserProvider>(
                                      context,
                                      listen: false);
                                  
                                  _isFavorite == true
                                      ? await userProv
                                          .removeMealFromFavorite(
                                              widget._meal!.id!)
                                          .then((_) {
                                          setState(() {
                                            icon = Icons.favorite_border;
                                            _isFavorite = false;
                                          });
                                        })
                                      : await userProv
                                          .addMealToFavorite(widget._meal!.id!)
                                          .then((_) {
                                          setState(() {
                                            icon = Icons.favorite_sharp;
                                            _isFavorite = true;
                                          });
                                        });
                                },
                                icon: Icon(icon,color: Colors.redAccent,)):Container(),
                            IconButton(
                                onPressed: () {
                                  if (userProv.logedUser != null) {
                                    cartProvider.addMealToCart(widget._meal!);
                                    basketProvider.addCartToBasket(
                                        widget._meal!.chefId!,
                                        cartProvider.cart,
                                        userProv.logedUser!.userID!);

                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${widget._meal!.title} added to your basket',
                                        ),
                                        duration: Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          onPressed: () {
                                            cartProvider.decreasCartQuantity();
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    MyRouter.pushPage(context, Authinticate());
                                  }
                                },
                                icon: Icon(
                                  Icons.shopping_cart_rounded,
                                  color: OrangeColor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: deviceSize.width * 0.01,
                      right: deviceSize.width * 0.01,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget._meal!.description!,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        // overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.01,
                  ),
                  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "By Chef: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          MyRouter.pushPage(context,
                              ChefProfileScreen(widget._meal!.chefId!));
                        },
                        child: Text(
                          chef.userName!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceSize.height * 0.02),
                  Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(left: deviceSize.width * 0.05),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star,color: Colors.amber,),
                                  Text(
                                    '${widget._meal!.rate}',
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.07,
                              ),
                              Text(
                                'Duration',
                                style: TextStyle(
                                  color: LightOrangeColor,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                '${widget._meal!.duration} m',
                                style: TextStyle(
                                  color: LightBlackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.07,
                              ),
                          
                              Text(
                                'Price',
                                style: TextStyle(
                                  color: LightOrangeColor,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                  '${widget._meal!.price}',
                                style: TextStyle(
                                  color: BlackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: Image.network(
                            widget._meal!.imageUrl!,
                            fit: BoxFit.cover,
                            width: deviceSize.width * 0.62,
                            height: deviceSize.height * 0.46,
                            alignment: Alignment.topLeft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: deviceSize.height * 0.04,
                  // ),
                  // Container(
                  //   alignment: Alignment.topLeft,
                  //   padding: EdgeInsets.only(
                  //     left: deviceSize.width * 0.07,
                  //     right: deviceSize.width * 0.01,
                  //   ),
                  //   child: Text(
                  //     "Categories",
                  //     style: TextStyle(
                  //       color: OrangeColor,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     left: deviceSize.width * 0.07,
                  //     right: deviceSize.width * 0.01,
                  //   ),
                  //   child: CategoryItemGrid(
                  //       mealCategories: widget._meal!.cats!.values.toList()),
                  // ),
                  Divider(
                    height: 30,
                  ),
                  userProv.logedUser != null
                      ? userProv.logedUser!.userID != widget._meal!.chefId!
                          ? Container(
                              child: RoundedButton(
                                width: deviceSize.width * 0.4,
                                color: OrangeColor,
                                text: "Add to basket",
                                textColor: Colors.white,
                                press: () {
                                  cartProvider.addMealToCart(widget._meal!);
                                  basketProvider.addCartToBasket(
                                      widget._meal!.chefId!,
                                      cartProvider.cart,
                                      userProv.logedUser!.userID!);

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${widget._meal!.title} added to your basket',
                                      ),
                                      duration: Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: () {
                                          cartProvider.decreasCartQuantity();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RoundedButton(
                                    width: deviceSize.width * 0.3,
                                    color: OrangeColor,
                                    text: "Edit",
                                    textColor: Colors.white,
                                    press: () {
                                      Navigator.pop(context);
                                      MyRouter.pushPage(
                                          context,
                                          AddNewMealScreen(
                                              meal: widget._meal!));
                                    },
                                  ),
                                  RoundedButton(
                                      width: deviceSize.width * 0.3,
                                      color: OrangeColor,
                                      text: "Delete",
                                      textColor: Colors.white,
                                      press: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  content: Text(
                                                      'are you sure you want to delete this meal?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(ctx)
                                                            .pop(false);
                                                      },
                                                    ),
                                                    FlatButton(
                                                        child: Text('Yes'),
                                                        onPressed: () async {
                                                          await Provider.of<
                                                                      MealProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteMeal(
                                                                  widget._meal!)
                                                              .then((_) {
                                                            Navigator.of(ctx)
                                                                .pop(true);
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                            MyRouter.pushPage(
                                                                context,
                                                                HomePage());
                                                          });
                                                        }),
                                                  ],
                                                ));
                                      }),
                                ],
                              ),
                            )
                      // for guest
                      : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(),
                    Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      top: deviceSize.height * 0.01,
                      left: deviceSize.width * 0.07,
                      bottom:deviceSize.height * 0.03 ,
                      right: deviceSize.width * 0.01,
                    ),
                    child: Text(
                      "Related Meals",
                      style: TextStyle(
                        color: OrangeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                     height: MediaQuery.of(context).size.height * 0.29,
                    child: _mealSuggestionBuilder()
                    ),
                    SizedBox(height: 30,)
                ],
              ),
            ),
          );
  }
  Widget _mealSuggestionBuilder(){
    return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),

            itemCount: mealsSuggestion.length,
            itemBuilder: (context, index) {
              return MealItem(mealsSuggestion[index]);
            },
          );
  }

  Widget MealRatingBuilder(context) {
    Size deviceSize = MediaQuery.of(context).size;

    return AlertDialog(
      content: Container(
        height: deviceSize.height * 0.42,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: IconButton(
                  icon: Icon(Icons.cancel_rounded, color: LightBlackColor),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
            ),
            Text(' price ', style: TextStyle(fontSize: 16)),
            MealRating(
              onChanged: (value) {
                print(value);
                setState(() {
                  price = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(' taste ', style: TextStyle(fontSize: 16)),
            MealRating(
              onChanged: (value) {
                print(value);

                setState(() {
                  taste = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(' cleanness ', style: TextStyle(fontSize: 16)),
            MealRating(
              onChanged: (value) {
                print(value);

                setState(() {
                  cleanness = value;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                await Provider.of<MealProvider>(context, listen: false)
                    .rateMeal(
                        widget._meal!, ((price + taste + cleanness) / 3).ceil())
                    .then((_) {
                  print(((price + taste + cleanness) / 3).ceil());

                  Navigator.of(context).pop(true);
                });
              },
              label: Text("Save"),
              backgroundColor: AmberColor,
              elevation: 0,
            )
          ],
        ),
      ),
    );
  }
}

//add this widget
// class CategoryItemGrid extends StatelessWidget {
//   List<String>? mealCategories;

//   CategoryItemGrid({this.mealCategories});

//   @override
//   Widget build(BuildContext context) {
//     final categoriesData =
//         Provider.of<CategoriesProvider>(context).dummy_categories;
//     Size deviceSize = MediaQuery.of(context).size;

//     return Container(
//       // height: deviceSize.height * 0.35,
//       child: GridView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: mealCategories!.length,
//         itemBuilder: (_, index) => Container(
//           //padding: EdgeInsets.only(top: 10, bottom: 10),
//           child: CategoryItem(mealCategories![index], categoriesColors[index]),
//         ),
//         shrinkWrap: true,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4, crossAxisSpacing: 20),
//       ),
//     );
//   }
// }

// class CategoryItem extends StatelessWidget {
//   final String? title;
//   final Color? color;

//   CategoryItem(this.title, this.color);

//   @override
//   Widget build(BuildContext context) {
//     Size deviceSize = MediaQuery.of(context).size;
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 15.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: color!,
//           borderRadius: BorderRadius.all(
//             Radius.circular(30.0),
//           ),
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.all(
//             Radius.circular(30.0),
//           ),
//           onTap: () {},
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.0),
//               child: Text(
//                 '$title',
//                 style: TextStyle(
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
