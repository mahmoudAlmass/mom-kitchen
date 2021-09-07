import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/category.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/modules/custom_search/custom_search_delegate.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/meal_detail_screen.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  Category? category;
  int? query;
  MealsScreen({this.category,this.query});
  @override
  _MealsScreenState createState() => _MealsScreenState(category: category,query: query);
}

class _MealsScreenState extends State<MealsScreen> {
  Category? category;
  int? query;


  _MealsScreenState({this.category,this.query});

  List<Meal> meals = [];
  bool _isLoading = true;
  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      if (category == null) {
        if(query==1){
                  await Provider.of<MealProvider>(context, listen: false)
            .getMostRated()
            .then((_) {
          setState(() {

            meals = Provider.of<MealProvider>(context, listen: false).mostRated;
            print(meals.length);
            _isLoading = false;
            _isInit = false;
          });
        });
        }else if(query==2){
            await Provider.of<MealProvider>(context, listen: false)
            .getFavoritesMeals(Provider.of<UserProvider>(context,listen:false).logedUser!.userID!)
            .then((value) {
          setState(() {

            meals = value;
            print(meals.length);
            _isLoading = false;
            _isInit = false;
          });
        });
        }
        else{
            await Provider.of<MealProvider>(context, listen: false)
            .getMeals()
            .then((_) {
          setState(() {
            meals = Provider.of<MealProvider>(context, listen: false).meals;
            _isLoading = false;
            _isInit = false;
          });
        });
        }

      } else {
        await Provider.of<MealProvider>(context, listen: false)
            .fetchAllMealInCategory(category!)
            .then((value) {
          setState(() {
            meals = value;
            _isLoading = false;
            _isInit = false;
          });
        });
      }
    }
    super.didChangeDependencies();
  }

  final scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    final mealProv = Provider.of<MealProvider>(context, listen: false);
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if(query==1){
        if (mealProv.hasNextMostRated) {
            mealProv.getMostRated();
        }
      }
      else{
        if (mealProv.hasNext) {
            mealProv.getMeals();
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return _isLoading
        ? LoadingWidget()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: deviceSize.height * 0.05,
                      left: deviceSize.width * 0.03,
                      right: deviceSize.width * 0.01,
                      bottom: deviceSize.height * 0.01,
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
                                Navigator.pop(context);
                              },
                            ),
                            // SizedBox(width: deviceSize.width * 0.03),
                            Text("Meals",
                                style: TextStyle(
                                    color: LightBlackColor, fontSize: 22)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            final data = Provider.of<MealProvider>(context,
                                    listen: false)
                                .getMealStream(meals);
                            final searchQueries =
                                Provider.of<AppProvider>(context, listen: false)
                                    .getQueriesStream();
                            print(searchQueries.length);
                            dynamic result = await showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(
                                  data: data, searchQueries: searchQueries),
                            );
                            if (result != null)
                              MyRouter.pushPage(context, MealDetail(result));
                          },
                        ),
                      ],
                    ),
                  ),
                  meals.length == 0
                      ? Text("no items yet ... ")
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            return MealItemBuilder(meals[index]);
                          },
                        ),
                ],
              ),
            ),
          );
  }
}

class MealItemBuilder extends StatelessWidget {
  Meal? _meal;

  MealItemBuilder(Meal _meal) {
    this._meal = _meal;
  }

  void selectMeal(BuildContext context) {
    // print('enter $title screen');
    // Navigator.of(context).pushNamed(MealDetail.routeName, arguments: id);

    MyRouter.pushPage(context, MealDetail(_meal!));
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(7.0),
        elevation: 4.0,
        child: InkWell(
          onTap: () {
            selectMeal(context);
          },
          child: Container(
            height: deviceSize.height * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0), color: Colors.white),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10.0),
                Container(
                  height: deviceSize.height * 0.17,
                  width: deviceSize.width * 0.3,
                  //fix
                  decoration: _meal!.imageUrl != null
                      ? BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(_meal!.imageUrl!),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(7.0))
                      : BoxDecoration(),
                ),
                SizedBox(width: deviceSize.width * 0.02),
                Flexible(
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: deviceSize.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _meal!.title!,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // SizedBox(width: deviceSize.width * 0.19),
                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AmberColor,
                                ),
                                Text(
                                  _meal!.rate.toString(),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.width * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Icon(Icons.schedule),
                                SizedBox(width: 5),
                            Text('${_meal!.duration} min',
                                style: TextStyle(
                                  fontSize: 16.0,
                                )), 
                              ],
                            ),
                          ),
                        
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Icon(Icons.monetization_on_outlined),
                                SizedBox(width: 5),
                            Text('${_meal!.price} ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                )),
                              ],
                            ),
                          ),
 
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
