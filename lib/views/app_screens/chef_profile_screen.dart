import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/googleMap/map_app.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/edit_chief_profile_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/meals_screen.dart';
import 'package:kitchen_ware_project/widgets/add_new_meal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ChefProfileScreen extends StatefulWidget {
  bool isExpanded = false;

  String cheifId;
  ChefProfileScreen(this.cheifId);

  @override
  _ChefProfileScreenState createState() => _ChefProfileScreenState(cheifId);
}

class _ChefProfileScreenState extends State<ChefProfileScreen> {
  _ChefProfileScreenState(this.cheifId);

  String cheifId;

  bool isExpanded = false;

  String? firstHalf;
  String? secondHalf;
  late int numOfLoves;
  User loadedChief = User();
  List<Meal> _mealsFromThisCheif = [];
  bool _isInit = true;
  bool _isLoading = true;
  bool _hadOrderedFromThisCheif = false;
  bool _hadLovedThisCheif = false;
  IconData icon = Icons.favorite_border;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final userProv = Provider.of<UserProvider>(context, listen: false);
      await userProv.fetchChiefByid(cheifId).then((value) async {
        await Provider.of<MealProvider>(context, listen: false)
            .mealsByCheifId(value.userID.toString())
            .then((value) async {
          if (userProv.logedUser != null) {
            for (var meal in value) {
              await userProv
                  .hadOrderdThisMealBefor(meal.id!)
                  .then((value) async {
                    
                if (value == true) {
              

                  setState(() {
                    _hadOrderedFromThisCheif = value;
                  });
                }
              });
            }
            await userProv
                .hadLovedThisCheif(cheifId, userProv.logedUser!.userID!)
                .then((value) {
              setState(() {
                _hadLovedThisCheif = value;
                if (value == true) {
                  icon = Icons.favorite_sharp;
                }
              });
            });
          }

          setState(() {
            _mealsFromThisCheif = value;
          });
        });

        setState(() {
          loadedChief = value;
          numOfLoves = loadedChief.numberOfLoves!;
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  String _buildCheifInfo(User loadedChief) {
    String introduction = loadedChief.introduction != null
        ? "introduction : ${loadedChief.introduction}"
        : 'introduction : ';
    String cheifName = loadedChief.userName != null
        ? "cheifName : ${loadedChief.userName}"
        : 'cheifName : ';
    String location = loadedChief.location != null
        ? "location : ${loadedChief.location}"
        : 'location : ';
    String openingTime = loadedChief.openingTime != null
        ? "openingTime : ${loadedChief.openingTime}"
        : 'openingTime : ';
    String closingTime = loadedChief.closingTime != null
        ? "closingTime : ${loadedChief.closingTime}"
        : 'closingTime : ';

    return cheifName +
        "\n" +
        introduction +
        "\n" +
        location +
        "\n" +
        openingTime +
        "\n" +
        closingTime +
        "\n";
  }

  @override
  Widget build(BuildContext context) {
    //bool isExpanded;
    var logedUser = Provider.of<UserProvider>(context, listen: false).logedUser;
    Size deviceSize = MediaQuery.of(context).size;

    String cheifInfo = _buildCheifInfo(loadedChief);

    return _isLoading
        ? LoadingWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: deviceSize.height * 0.03,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: deviceSize.height / 2.9,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: deviceSize.height / 3.5,
                        width: double.infinity,
                        //fix
                        child: CachedNetworkImage(
                          imageUrl:
                              loadedChief.backgroungProfileImage.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 50.0,
                            width: 50.0,
                            child: ShimmerLoading(),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Image.asset('assets/images/person-icon.png'),
                            radius: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceSize.height / 4.8,
                        left: deviceSize.width / 2.6,
                        child: Container(
                          height: deviceSize.height * 0.13,
                          width: deviceSize.height * 0.13,
                          //fix
                          child: CachedNetworkImage(
                            imageBuilder: (context, _) => Container(
                              height: deviceSize.height * 0.13,
                              width: deviceSize.height * 0.13,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        loadedChief.imageUrl.toString(),
                                      ))),
                            ),
                            imageUrl: loadedChief.imageUrl.toString(),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              child: ShimmerLoading(),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child:
                                  Image.asset('assets/images/person-icon.png'),
                              radius: 20,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(color: GrayColor, width: 5
                                // width: deviceSize.height * 0.1,

                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceSize.height * 0.01,
                        left: deviceSize.width * 0.03,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: GrayColor.withOpacity(0.4),
                            )
                          ]),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_sharp,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _hadOrderedFromThisCheif == true
                          ? Row(
                              children: [
                                SizedBox(width: deviceSize.width * 0.02),
                                IconButton(
                                    onPressed: () async {
                                      final userProv =
                                          Provider.of<UserProvider>(context,
                                              listen: false);
                                      final logedUser = userProv.logedUser!;
                                      _hadLovedThisCheif == true
                                          ? await userProv
                                              .decreaseNumberOfLoves(
                                                  cheifId,
                                                  loadedChief.numberOfLoves! -
                                                      1,
                                                  logedUser.userID!)
                                              .then((_) {
                                              setState(() {
                                                numOfLoves = numOfLoves - 1;
                                                icon = Icons.favorite_border;
                                                _hadLovedThisCheif = false;
                                              });
                                            })
                                          : await userProv
                                              .increaseNumberOfLoves(
                                                  cheifId,
                                                  loadedChief.numberOfLoves! +
                                                      1,
                                                  logedUser.userID!)
                                              .then((_) {
                                              setState(() {
                                                numOfLoves = numOfLoves + 1;
                                                icon = Icons.favorite_sharp;
                                                _hadLovedThisCheif = true;
                                              });
                                            });
                                    },
                                    icon: Icon(
                                      icon,
                                      color: Colors.redAccent,
                                    )),
                                Text("$numOfLoves"),
                                SizedBox(width: deviceSize.width * 0.02),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          logedUser != null
                              ? loadedChief.userID == logedUser.userID
                                  ? IconButton(
                                      onPressed: () {
                                        MyRouter.pushPage(
                                            context,
                                            EditChefProfileScreen(
                                                user: loadedChief));
                                      },
                                      icon: Icon(Icons.edit))
                                  : Container()
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: deviceSize.height * 0.02),
                  Column(children: <Widget>[
                    ConstrainedBox(
                        constraints: widget.isExpanded
                            ? BoxConstraints()
                            : BoxConstraints(
                                maxHeight: deviceSize.height * 0.05),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: deviceSize.width * 0.03,
                              right: deviceSize.width * 0.03),
                          alignment: Alignment.topLeft,
                          child: Text(
                            cheifInfo,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            style:
                                TextStyle(color: LightBlackColor, fontSize: 16),
                          ),
                        )),
                    widget.isExpanded
                        ? Container(
                            height: 20,
                            child: FlatButton(
                                child: Icon(Icons.keyboard_arrow_up),
                                onPressed: () =>
                                    setState(() => widget.isExpanded = false)),
                          )
                        : Container(
                            height: 40,
                            child: FlatButton(
                                child: Icon(Icons.keyboard_arrow_down),
                                onPressed: () =>
                                    setState(() => widget.isExpanded = true)),
                          )
                  ]),
                  SizedBox(height: deviceSize.height * 0.02),
            
                  SizedBox(height: 10.0),
                  logedUser != null
                      ? loadedChief.userID == logedUser.userID
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceSize.width * 0.03),
                                  alignment: Alignment.topLeft,
                                  child: Text("My Meals"),
                                ),
                                
                                InkWell(
                                  onTap: () {
                                    MyRouter.pushPageReplacement(context,
                                        AddNewMealScreen(meal: new Meal()));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        semanticLabel: "add meal",
                                        color: AmberColor,
                                        size: 20,
                                      ),
                                      Text(
                                        "add meal",
                                        style: TextStyle(
                                            color: AmberColor, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: deviceSize.width * 0.02,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceSize.width * 0.03),
                                  alignment: Alignment.topLeft,
                                  child: Text("Cheif Meals"),
                                ),
                              ],
                            )
                      : Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: deviceSize.width * 0.03),
                              alignment: Alignment.topLeft,
                              child: Text("Cheif Meals"),
                            ),
                          ],
                        ),
                  SizedBox(height: 10.0),


                  _mealsFromThisCheif.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _mealsFromThisCheif.length,
                          itemBuilder: (context, index) {
                            return MealItemBuilder(
                              _mealsFromThisCheif[index],
                            );
                          },
                        )
                      : Text("no posts yet"),
                ],
              ),
            ),
          );
  }
}
